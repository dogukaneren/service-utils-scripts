#!/usr/bin/env python3
"""
Single-file Flask app that provides a minimal browser UI to interact with a local
llama3.2 model started by Ollama (you wrote: `ollama run llama3.2`).

How it works
- Serves a small HTML page at `/` with a text input and a chat area.
- `/api/chat` accepts POST JSON {"prompt": "..."} and runs `ollama run llama3.2 --prompt "..."`
  via subprocess and returns the model output as JSON.

Notes / caveats
- This is intentionally minimal for simplicity and for small models.
- It uses the `ollama` CLI (so `ollama` must be in PATH and the model must be available locally).
- For production or heavy usage prefer the Ollama HTTP API (if configured) or a more robust server
  implementation (streaming, timeouts, authentication, rate limiting, error handling improvements).

Run:
  python3 -m venv venv
  source venv/bin/activate
  pip install flask
  python3 ollama-llama3-ui.py

Open http://localhost:5000 in your browser.
"""

from flask import Flask, request, jsonify, Response
import subprocess
import shlex
import html

app = Flask(__name__)

INDEX_HTML = '''
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>ollama · llama3.2 — simple UI</title>
  <style>
    body{font-family:Inter,system-ui,Segoe UI,Arial;margin:0;padding:0;background:#0f172a;color:#e6eef8}
    .wrap{max-width:900px;margin:30px auto;padding:20px;background:#071028;border-radius:8px}
    textarea{width:100%;height:120px;padding:12px;border-radius:6px;border:1px solid #203040;background:#071a2b;color:#e6eef8}
    button{background:#2563eb;color:white;padding:10px 14px;border-radius:6px;border:0;cursor:pointer}
    pre{white-space:pre-wrap;background:#031025;padding:12px;border-radius:6px;color:#cfe9ff}
    .controls{display:flex;gap:8px;align-items:center}
  </style>
</head>
<body>
  <div class="wrap">
    <h2>ollama · llama3.2 — simple UI</h2>
    <p>Write a prompt and press <strong>Send</strong>. The server runs <code>ollama run llama3.2</code> and returns the output.</p>

    <div>
      <label for="prompt">Prompt</label>
      <textarea id="prompt" placeholder="Write your prompt here..."></textarea>
    </div>

    <div class="controls" style="margin-top:8px">
      <button id="send">Send</button>
      <label style="font-size:13px;color:#9fb7d9">Max tokens: <input id="max_tokens" type="number" value="512" min="16" max="4096" style="width:80px;margin-left:6px"></label>
    </div>

    <h3>Response</h3>
    <pre id="response">(waiting)</pre>
  </div>

  <script>
  const sendBtn = document.getElementById('send');
  const promptEl = document.getElementById('prompt');
  const respEl = document.getElementById('response');
  const maxTokensEl = document.getElementById('max_tokens');

  sendBtn.addEventListener('click', async ()=>{
    const prompt = promptEl.value.trim();
    if(!prompt){alert('Write a prompt');return}
    respEl.textContent = 'Thinking...';
    try{
      const r = await fetch('/api/chat',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({prompt,max_tokens:parseInt(maxTokensEl.value)||512})});
      if(!r.ok){const t=await r.text();respEl.textContent='Error: '+t;return}
      const data = await r.json();
      respEl.textContent = data.output || '(no output)';
    }catch(e){respEl.textContent = 'Fetch error: '+e.message}
  });
  </script>
</body>
</html>
'''


@app.route('/')
def index():
    return Response(INDEX_HTML, mimetype='text/html')


@app.route('/api/chat', methods=['POST'])
def chat():
    j = request.get_json(force=True)
    prompt = j.get('prompt','')
    max_tokens = int(j.get('max_tokens', 512))
    if not prompt:
        return jsonify({'error':'empty prompt'}), 400

    # Safety: limit prompt length
    if len(prompt) > 20000:
        return jsonify({'error':'prompt too long'}), 400

    # Build the CLI command. We use subprocess to call ollama CLI.
    # Note: if you prefer HTTP API, replace this block with requests.post(...) to the local Ollama server.
    # Using shlex to escape the prompt in the shell-safe way when passing as argument list.

    # Ollama CLI usage: `ollama run MODEL --prompt "..."` — we call it without a shell.
    cmd = ['ollama', 'run', 'llama3.2', '--quiet', '--prompt', prompt]

    try:
        # run the command, capture output
        proc = subprocess.run(cmd, capture_output=True, text=True, timeout=60)
    except subprocess.TimeoutExpired:
        return jsonify({'error':'model timeout'}), 504
    except FileNotFoundError:
        return jsonify({'error':"'ollama' command not found. Is ollama installed and in PATH?"}), 500

    if proc.returncode != 0:
        err = proc.stderr.strip() or proc.stdout.strip() or 'unknown error'
        return jsonify({'error':'ollama failed','details':err}), 500

    output = proc.stdout.strip()

    # Basic HTML-escape just in case
    out_safe = html.escape(output)
    return jsonify({'output': out_safe})


if __name__ == '__main__':
    # Bind to all interfaces so you can open from other machines if desired. Use a reverse proxy in prod.
    app.run(host='0.0.0.0', port=5000, debug=False)
