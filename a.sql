-- public.egm_alarm definition

-- Drop table

-- DROP TABLE public.egm_alarm;

CREATE TABLE public.egm_alarm (
	kurum_adi varchar(100) NULL,
	il_kodu varchar(50) NULL,
	ilce_adi varchar(50) NULL,
	lokasyon_adi varchar(100) NULL,
	x_koordinat varchar(50) NULL,
	y_koordinat varchar(50) NULL,
	yon varchar(50) NULL,
	plaka varchar(50) NULL,
	durumu int2 NULL,
	alarm_nedeni_aciklamasi varchar(100) NULL,
	alarm_seviyesi varchar(50) NULL,
	marka varchar(50) NULL,
	modelyili varchar(100) NULL,
	gecis_tarihi timestamp(6) NULL,
	renk varchar(50) NULL,
	ticari_ad varchar(50) NULL,
	tip varchar(50) NULL,
	durum varchar(200) NULL,
	sakinca_durum_aciklamasi varchar(100) NULL,
	alarm_id bpchar(32) NULL,
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	CONSTRAINT egm_alarm_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_egm_alarm_gecis_tarihi ON public.egm_alarm USING btree (gecis_tarihi);
CREATE INDEX idx_egm_alarm_plaka ON public.egm_alarm USING btree (plaka);
