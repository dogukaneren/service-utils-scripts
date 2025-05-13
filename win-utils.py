import psutil
import GPUtil
import platform
import subprocess
import wmi

def get_cpu_info():
    print("CPU Bilgisi:")
    print(f"Toplam Çekirdek Sayısı: {psutil.cpu_count(logical=False)}")
    print(f"Toplam Lojik Çekirdek Sayısı: {psutil.cpu_count(logical=True)}")
    print(f"CPU Kullanımı: {psutil.cpu_percent(interval=1)}%")
    print(f"CPU Frekansı: {psutil.cpu_freq().current} MHz")
    
    try:
        result = subprocess.run(
            ['powershell', '-Command', "Get-WmiObject Win32_Processor | Select-Object -ExpandProperty Name"],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        
        cpu_model = result.stdout.strip()
        if cpu_model:
            print(f"Intel CPU: {cpu_model}")
        else:
            print(f"İşlemci Modeli: Bilgi alınamadı")
    except Exception as e:
        print(f"Intel CPU bilgisi alınırken hata oluştu: {e}")
    print()

def get_memory_info():
    print("Bellek Bilgisi:")
    memory = psutil.virtual_memory()
    print(f"Toplam Bellek: {memory.total / (1024 ** 3):.2f} GB")
    print(f"Kullanılan Bellek: {memory.used / (1024 ** 3):.2f} GB")
    print(f"Boş Bellek: {memory.available / (1024 ** 3):.2f} GB")
    print(f"Bellek Kullanımı: {memory.percent}%")
    print()

def get_disk_info():
    print("Disk Bilgisi:")
    disk = psutil.disk_usage('/')
    print(f"Toplam Disk Alanı: {disk.total / (1024 ** 3):.2f} GB")
    print(f"Kullanılan Disk Alanı: {disk.used / (1024 ** 3):.2f} GB")
    print(f"Boş Disk Alanı: {disk.free / (1024 ** 3):.2f} GB")
    print(f"Disk Kullanımı: {disk.percent}%")
    print()

def get_gpu_info():
    print("GPU Bilgisi:")
    gpus = GPUtil.getGPUs()
    for gpu in gpus:
        print(f"GPU Adı: {gpu.name}")
        print(f"GPU Belleği Toplam: {gpu.memoryTotal} MB")
        print(f"GPU Belleği Kullanılan: {gpu.memoryUsed} MB")
        print(f"GPU Belleği Boş: {gpu.memoryFree} MB")
        print(f"GPU Kullanımı: {gpu.memoryUtil * 100}%")
        print(f"GPU Sıcaklık: {gpu.temperature} C")
        print()

def get_intel_gpu_info():
    print("Intel GPU Bilgisi:")
    try:
        c = wmi.WMI(namespace="root\\wmi")
        for gpu in c.MSAcpi_ThermalZoneTemperature():
            print(f"Intel GPU Sıcaklık: {gpu.CurrentTemperature / 10.0}°C")  # WMI'nin verdiği sıcaklık değeri 10 ile bölünmeli
        print()
    except Exception as e:
        print(f"Intel GPU bilgisi alınırken hata oluştu: {e}")

def get_system_info():
    print("Sistem Bilgisi:")
    print(f"Sistem: {platform.system()} {platform.release()}")
    print(f"İşlemci: {platform.processor()}")
    print(f"Bit: {platform.architecture()[0]}")
    print()

if __name__ == "__main__":
    get_system_info()
    get_cpu_info()
    get_memory_info()
    get_disk_info()
    get_gpu_info()
    get_intel_gpu_info()
