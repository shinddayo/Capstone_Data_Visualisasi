options(scipen = 99) # me-non-aktifkan scientific notation
library(tidyverse)
library(readxl)
library(scales) # membaca data
library(glue)
library(plotly)
library(leaflet)
library(echarts4r)
library(DT)

library(shinydashboard)
library(shiny)

jenis_sampah <- read_xlsx("Data_Komposisi_Jenis_Sampah_SIPSN_KLHK.xlsx")
sumber_sampah <- read_xlsx("Data_Komposisi_Sumber_Sampah_SIPSN_KLHK.xlsx")
timbunan_sampah <- read_xlsx("Data_Timbulan_Sampah_SIPSN_KLHK.xlsx")
capaian <- read_xlsx("Data_Capaian_SIPSN_KLHK.xlsx")
rth <- read_xlsx("Data_RTH_SIPSN_KLHK.xlsx")

bank_sampah_unit <- read_xlsx("Data_Bank_sampah_unit.xlsx")
bank_sampah_induk <- read_xlsx("Data_Bank_sampah_induk.xlsx")
biodigester <- read_xlsx("Data_Biodigester.xlsx")
gasifikasi <- read_xlsx("Data_GASIFIKASI.xlsx")
insinetor <- read_xlsx("Data_Insinerator.xlsx")
itf <- read_xlsx("Data_ITF.xlsx")
pdu <- read_xlsx("Data_PDU.xlsx")
sek_informal <- read_xlsx("Data_Pengepul.xlsx")
pirolisis <- read_xlsx("Data_Pirolisis.xlsx")
poo <- read_xlsx("data_poo.xlsx")
rdf <- read_xlsx("Data_RDF.xlsx")
rmh_kompos <- read_xlsx("Data_Rumah_Kompos.xlsx")
tpa <- read_xlsx("Data_TPA.xlsx")
tps <- read_xlsx("Data_TPS_DuluarTPA.xlsx")
tps3r <- read_xlsx("Data_TPS3R.xlsx")
kpompos_RT <- read_xlsx("Data_Komposting_RT.xlsx")
lat <- read_xlsx("latitude.xlsx")



jenis_sampah <- jenis_sampah %>% 
  rename_with(~ gsub("-", " ", .x))%>% 
  rename_with(~ gsub("[[:punct:]]", "", .x))


sumber_sampah <- sumber_sampah %>% 
  rename_with(~ gsub("-", " ", .x))%>% 
  rename_with(~ gsub("ton", "", .x))%>% 
  rename_with(~ gsub("[[:punct:]]", "", .x))

timbunan_sampah <- timbunan_sampah %>% 
  rename_with(~ gsub("[[:punct:]]", "", .x))%>% 
  rename_with(~ gsub(" ", "_", .x))%>% 
  rename_with(~ gsub("ton", "_Ton", .x))

capaian <- capaian %>% 
  rename_with(~ gsub("%", "Perc", .x))%>% 
  rename_with(~ gsub("[[:punct:]]", "", .x))%>% 
  rename_with(~ gsub(" ", "_", .x))

rth <- rth %>% 
  rename_with(~ gsub("-", " ", .x))%>% 
  rename_with(~ gsub("[[:punct:]]", "", .x))

bank_sampah_unit <- bank_sampah_unit %>% 
  rename_with(~ gsub("[[:punct:]]", "", .x))%>% 
  rename_with(~ gsub(" ", "_", .x))%>% 
  rename_with(~ gsub("tonthn", "TonThn", .x))%>% 
  mutate(
    Sampahmasuk_TonThn = Sampahmasuk_kgthn/1000,
    Sampahterkelola_TonThn=Sampahterkelola_kgthn/1000,
    Fasilitas_Group="Bank Sampah"
  )

bank_sampah_induk <- bank_sampah_induk %>% 
  rename_with(~ gsub("[[:punct:]]", "", .x))%>% 
  rename_with(~ gsub(" ", "_", .x))%>% 
  rename_with(~ gsub("tonthn", "TonThn", .x)) %>% 
  mutate(
    Fasilitas_Group="Bank Sampah"
  )

biodigester <- biodigester %>% 
  rename_with(~ gsub("[[:punct:]]", "", .x))%>% 
  rename_with(~ gsub(" ", "_", .x))%>% 
  rename_with(~ gsub("tonthn", "TonThn", .x))%>% 
  mutate(
    Fasilitas_Group="Sumber Energi"
  )

gasifikasi <- gasifikasi %>% 
  rename_with(~ gsub("[[:punct:]]", "", .x))%>% 
  rename_with(~ gsub(" ", "_", .x))%>% 
  rename_with(~ gsub("tonthn", "TonThn", .x))%>% 
  mutate(
    Fasilitas_Group="Sumber Energi"
  )

insinetor <- insinetor %>% 
  rename_with(~ gsub("[[:punct:]]", "", .x))%>% 
  rename_with(~ gsub(" ", "_", .x))%>% 
  rename_with(~ gsub("tonthn", "TonThn", .x))%>% 
  mutate(
    Fasilitas_Group="Sumber Energi"
  )


itf <- itf %>% 
  rename_with(~ gsub("[[:punct:]]", "", .x))%>% 
  rename_with(~ gsub(" ", "_", .x))%>% 
  rename_with(~ gsub("tonthn", "TonThn", .x))%>% 
  mutate(
    Fasilitas_Group="TPS3R/PDU/ITF"
  )


pdu <- pdu %>% 
  rename_with(~ gsub("[[:punct:]]", "", .x))%>% 
  rename_with(~ gsub(" ", "_", .x))%>% 
  rename_with(~ gsub("tonthn", "TonThn", .x))%>% 
  mutate(
    Fasilitas_Group="TPS3R/PDU/ITF"
  )

sek_informal <- sek_informal %>% 
  rename_with(~ gsub("[[:punct:]]", "", .x))%>% 
  rename_with(~ gsub(" ", "_", .x))%>% 
  rename_with(~ gsub("tonthn", "TonThn", .x)) %>% 
  mutate(
    Pengelola="Masyarakat",
    Fasilitas_Group="Sektor Internal"
  )

pirolisis <- pirolisis %>% 
  rename_with(~ gsub("[[:punct:]]", "", .x))%>% 
  rename_with(~ gsub(" ", "_", .x))%>% 
  rename_with(~ gsub("tonthn", "TonThn", .x))%>% 
  mutate(
    Fasilitas_Group="Sumber Energi"
  )

poo <- poo %>% 
  rename_with(~ gsub("[[:punct:]]", "", .x))%>% 
  rename_with(~ gsub(" ", "_", .x))%>% 
  rename_with(~ gsub("tonthn", "TonThn", .x))%>% 
  mutate(
    Fasilitas_Group="Komposting"
  )

rdf <- rdf %>% 
  rename_with(~ gsub("[[:punct:]]", "", .x))%>% 
  rename_with(~ gsub(" ", "_", .x))%>% 
  rename_with(~ gsub("tonthn", "TonThn", .x))%>% 
  mutate(
    Fasilitas_Group="Sumber Energi"
  )

rmh_kompos <- rmh_kompos %>% 
  rename_with(~ gsub("[[:punct:]]", "", .x))%>% 
  rename_with(~ gsub(" ", "_", .x))%>% 
  rename_with(~ gsub("tonthn", "TonThn", .x))%>% 
  mutate(
    Fasilitas_Group="Komposting"
  )

tpa <- tpa %>% 
  rename_with(~ gsub("[[:punct:]]", "", .x))%>% 
  rename_with(~ gsub(" ", "_", .x))%>% 
  rename_with(~ gsub("tonthn", "TonThn", .x))%>% 
  mutate(
    Sampahterkelola_TonThn=0.0,
    Fasilitas_Group="TPA"
  )

tps <- tps %>% 
  rename_with(~ gsub("[[:punct:]]", "", .x))%>% 
  rename_with(~ gsub(" ", "_", .x))%>% 
  rename_with(~ gsub("tonthn", "TonThn", .x))%>% 
  mutate(
    Fasilitas_Group="TPS3R/PDU/IT"
  )

tps3r <- tps3r %>% 
  rename_with(~ gsub("[[:punct:]]", "", .x))%>% 
  rename_with(~ gsub(" ", "_", .x))%>% 
  rename_with(~ gsub("tonthn", "TonThn", .x))%>% 
  mutate(
    Fasilitas_Group="TPS3R/PDU/ITF"
  )

kpompos_RT <- kpompos_RT %>% 
  rename_with(~ gsub("[[:punct:]]", "", .x))%>% 
  rename_with(~ gsub(" ", "_", .x))%>% 
  rename_with(~ gsub("tonthn", "TonThn", .x))%>% 
  mutate(
    Fasilitas_Group="Komposting"
  )


pengolah<-bank_sampah_unit %>% select(Tahun,Provinsi,KabupatenKota,Nama_Fasilitas,Jenis,Status,Sampahmasuk_TonThn,Sampahterkelola_TonThn,Pengelola,Fasilitas_Group)

pengolah <- rbind(pengolah, bank_sampah_induk%>% select(Tahun,Provinsi,KabupatenKota,Nama_Fasilitas,Jenis,Status,Sampahmasuk_TonThn,Sampahterkelola_TonThn,Pengelola,Fasilitas_Group))
pengolah <- rbind(pengolah, biodigester%>% select(Tahun,Provinsi,KabupatenKota,Nama_Fasilitas,Jenis,Status,Sampahmasuk_TonThn,Sampahterkelola_TonThn,Pengelola,Fasilitas_Group))
pengolah <- rbind(pengolah, gasifikasi%>% select(Tahun,Provinsi,KabupatenKota,Nama_Fasilitas,Jenis,Status,Sampahmasuk_TonThn,Sampahterkelola_TonThn,Pengelola,Fasilitas_Group))
pengolah <- rbind(pengolah, insinetor%>% select(Tahun,Provinsi,KabupatenKota,Nama_Fasilitas,Jenis,Status,Sampahmasuk_TonThn,Sampahterkelola_TonThn,Pengelola,Fasilitas_Group))
pengolah <- rbind(pengolah, itf%>% select(Tahun,Provinsi,KabupatenKota,Nama_Fasilitas,Jenis,Status,Sampahmasuk_TonThn,Sampahterkelola_TonThn,Pengelola,Fasilitas_Group))
pengolah <- rbind(pengolah, pdu%>% select(Tahun,Provinsi,KabupatenKota,Nama_Fasilitas,Jenis,Status,Sampahmasuk_TonThn,Sampahterkelola_TonThn,Pengelola,Fasilitas_Group))
pengolah <- rbind(pengolah, sek_informal%>% select(Tahun,Provinsi,KabupatenKota,Nama_Fasilitas,Jenis,Status,Sampahmasuk_TonThn,Sampahterkelola_TonThn,Pengelola,Fasilitas_Group))
pengolah <- rbind(pengolah, pirolisis%>% select(Tahun,Provinsi,KabupatenKota,Nama_Fasilitas,Jenis,Status,Sampahmasuk_TonThn,Sampahterkelola_TonThn,Pengelola,Fasilitas_Group))
pengolah <- rbind(pengolah, poo%>% select(Tahun,Provinsi,KabupatenKota,Nama_Fasilitas,Jenis,Status,Sampahmasuk_TonThn,Sampahterkelola_TonThn,Pengelola,Fasilitas_Group))
pengolah <- rbind(pengolah, rdf%>% select(Tahun,Provinsi,KabupatenKota,Nama_Fasilitas,Jenis,Status,Sampahmasuk_TonThn,Sampahterkelola_TonThn,Pengelola,Fasilitas_Group))
pengolah <- rbind(pengolah, rmh_kompos%>% select(Tahun,Provinsi,KabupatenKota,Nama_Fasilitas,Jenis,Status,Sampahmasuk_TonThn,Sampahterkelola_TonThn,Pengelola,Fasilitas_Group))
pengolah <- rbind(pengolah, tpa%>% select(Tahun,Provinsi,KabupatenKota,Nama_Fasilitas,Jenis,Status,Sampahmasuk_TonThn,Sampahterkelola_TonThn,Pengelola,Fasilitas_Group))
pengolah <- rbind(pengolah, tps%>% select(Tahun,Provinsi,KabupatenKota,Nama_Fasilitas,Jenis,Status,Sampahmasuk_TonThn,Sampahterkelola_TonThn,Pengelola,Fasilitas_Group))
pengolah <- rbind(pengolah, tps3r%>% select(Tahun,Provinsi,KabupatenKota,Nama_Fasilitas,Jenis,Status,Sampahmasuk_TonThn,Sampahterkelola_TonThn,Pengelola,Fasilitas_Group))
pengolah <- rbind(pengolah, kpompos_RT%>% select(Tahun,Provinsi,KabupatenKota,Nama_Fasilitas,Jenis,Status,Sampahmasuk_TonThn,Sampahterkelola_TonThn,Pengelola,Fasilitas_Group))



pengolah<- pengolah %>% 
  mutate(
    Pengelola=replace_na(Pengelola,"Lainnya"),
    Tahun = as.factor(Tahun),
    Provinsi = as.factor(Provinsi),
    KabupatenKota = as.factor(KabupatenKota),
    Jenis = as.factor(Jenis),
    Status = as.factor(Status),
    Pengelola = as.factor(Pengelola),
    Fasilitas_Group = as.factor(Fasilitas_Group)
  ) %>% 
  filter(is.na(Jenis)==FALSE)

tpa<- tpa %>% 
  mutate(
    Tahun = as.factor(Tahun),
    Provinsi = as.factor(Provinsi),
    KabupatenKota = as.factor(KabupatenKota),
    Jenis = as.factor(Jenis),
    Status = as.factor(Status),
    Pengelola = as.factor(Pengelola),
    Kelurahan = as.factor(Kelurahan),
    Kecamatan = as.factor(Kecamatan),
    Pencatatan = as.factor(Pencatatan),
    Sistem_Operasional = as.factor(Sistem_Operasional),
    Ada_Drainase = as.factor(Ada_Drainase)
  )

timbunan_sampah<- timbunan_sampah %>% 
  mutate(
    Tahun = as.factor(Tahun),
    Provinsi = as.factor(Provinsi),
    KabupatenKota = as.factor(KabupatenKota),
    key=glue("{Tahun}{Provinsi}{KabupatenKota}")
  )

capaian<- capaian %>% 
  mutate(
    Pengurangan_Sampah_Tahunan=replace_na(Pengurangan_Sampah_Tahunan,0),
    PercPengurangan_Sampah_Tahunan=replace_na(PercPengurangan_Sampah_Tahunan,0),
    Penanganan_Sampah_Tahunan=replace_na(Penanganan_Sampah_Tahunan,0),
    PercPenanganan_Sampah_Tahunan=replace_na(PercPenanganan_Sampah_Tahunan,0),
    Daur_ulang_Sampah_Tahunan=replace_na(Daur_ulang_Sampah_Tahunan,0),
    Bahan_baku_Sampah_Tahunan=replace_na(Bahan_baku_Sampah_Tahunan,0),
    
    Recycling_Tahunan=Bahan_baku_Sampah_Tahunan+Daur_ulang_Sampah_Tahunan,
    
    Tahun = as.factor(Tahun),
    Provinsi = as.factor(Provinsi),
    KabupatenKota = as.factor(Kabupaten_Kota),
    
    key=glue("{Tahun}{Provinsi}{KabupatenKota}")
  ) %>% 
  select(-Kabupaten_Kota)

jenis_sampah_long<-jenis_sampah %>% 
  pivot_longer(cols = c("Sisa Makanan ", "Kayu Ranting ", "Kertas Karton ","Plastik","Logam","Kain","Karet  Kulit ","Kaca","Lainnya"), names_to = "Jenis",values_to="percentage") %>% 
  filter(
    is.na(percentage)==FALSE
  )

jenis_sampah_long<- jenis_sampah_long %>% 
  mutate(
    Tahun = as.factor(Tahun),
    Provinsi = as.factor(Provinsi),
    KabupatenKota = as.factor(KabupatenKota),
    Jenis = as.factor(Jenis)
  )

sumber_sampah_long<-sumber_sampah %>% 
  pivot_longer(cols = c("Rumah Tangga", "Perkantoran","Pasar","Perniagaan","Fasilitas Publik","Kawasan","Lain"), names_to = "Sumber",values_to="Weight_Ton") %>% 
  filter(
    is.na(Weight_Ton)==FALSE
  )

sumber_sampah_long<- sumber_sampah_long %>% 
  mutate(
    Tahun = as.factor(Tahun),
    Provinsi = as.factor(Provinsi),
    KabupatenKota = as.factor(KabupatenKota),
    Sumber = as.factor(Sumber)
  )

sampah <- left_join(capaian,timbunan_sampah[,c("key","Timbulan_Sampah_Harian_Ton")],by=c("key"="key") )

sampah_Tahunan <- sampah %>% 
  group_by(Tahun) %>% 
  summarise(
    Timbulan_Sampah=sum(Timbulan_Sampah_Tahunan),
    Sampah_Terkelola=sum(Sampah_Terkelola_Tahunan),
    Recycling=sum(Recycling_Tahunan),
    Timbulan_Harian_Ton=sum(Timbulan_Sampah_Harian_Ton),
    Perc_Sampah_Terkelola=Sampah_Terkelola/Timbulan_Sampah,
    Perc_Recycling=Recycling/Timbulan_Sampah,
    Perc_Recycling1=Recycling/Sampah_Terkelola
  )


pengolah_Tahunan <-pengolah %>% 
  group_by(Tahun,Provinsi,KabupatenKota,Nama_Fasilitas) %>% 
  summarise(
    Sampahmasuk_TonThn=sum(Sampahmasuk_TonThn),
    Sampahterkelola_TonThn=sum(Sampahterkelola_TonThn),
    .groups = "drop"
  ) %>% 
  ungroup() %>% 
  group_by(Tahun) %>% 
  summarise(
    Jumlah_Fasilitas=n(),
    Sampahmasuk_TonThn=sum(Sampahmasuk_TonThn),
    Sampahterkelola_TonThn=sum(Sampahterkelola_TonThn),
    .groups = "drop"
  ) %>% 
  ungroup()



Bank_sampah_Tahunan <-pengolah %>% 
  filter(Fasilitas_Group=="Bank Sampah") %>% 
  group_by(Tahun,Provinsi,KabupatenKota,Nama_Fasilitas) %>% 
  summarise(
    Sampahmasuk_TonThn=sum(Sampahmasuk_TonThn),
    Sampahterkelola_TonThn=sum(Sampahterkelola_TonThn),
    .groups = "drop"
  ) %>% 
  ungroup() %>% 
  group_by(Tahun) %>% 
  summarise(
    Jumlah_Fasilitas=n(),
    Sampahmasuk_TonThn=sum(Sampahmasuk_TonThn),
    Sampahterkelola_TonThn=sum(Sampahterkelola_TonThn),
    .groups = "drop"
  ) %>% 
  ungroup()


pengolah_Tahunan <-pengolah %>% 
  group_by(Tahun,Provinsi,KabupatenKota,Nama_Fasilitas) %>% 
  summarise(
    Sampahmasuk_TonThn=sum(Sampahmasuk_TonThn),
    Sampahterkelola_TonThn=sum(Sampahterkelola_TonThn),
    .groups = "drop"
  ) %>% 
  ungroup() %>% 
  group_by(Tahun) %>% 
  summarise(
    Jumlah_Fasilitas=n(),
    Sampahmasuk_TonThn=sum(Sampahmasuk_TonThn),
    Sampahterkelola_TonThn=sum(Sampahterkelola_TonThn),
    .groups = "drop"
  ) %>% 
  ungroup()

komposisi_jenis <- jenis_sampah_long %>% 
  group_by(Tahun,Jenis) %>% 
  summarise(
    Perc=mean(percentage),
    .groups = 'drop'
  ) %>% 
  ungroup() %>% 
  arrange(desc(Perc))

sumber_tahunan <- sumber_sampah_long %>% 
  group_by(Tahun) %>% 
  summarise(
    Total=sum(Weight_Ton),
    .groups = 'drop'
  ) 

komposisi_sumber <- sumber_sampah_long %>% 
  group_by(Tahun,Sumber) %>% 
  summarise(
    Weight=sum(Weight_Ton),
    .groups = 'drop'
  ) %>% 
  ungroup()

komposisi_sumber <- left_join(komposisi_sumber,sumber_tahunan,by=c("Tahun"="Tahun") )
komposisi_sumber<- komposisi_sumber %>% 
  mutate(
    Perc=Weight/Total
  ) %>% 
  arrange(desc(Weight))


pengolah_lat<-pengolah %>% 
  group_by(Tahun,Provinsi,KabupatenKota,Nama_Fasilitas,Fasilitas_Group) %>% 
  summarise(
    Sampahmasuk_TonThn=sum(Sampahmasuk_TonThn),
    Sampahterkelola_TonThn=sum(Sampahterkelola_TonThn)
  ) %>% 
  ungroup() %>% 
  group_by(Tahun,Provinsi,KabupatenKota,Fasilitas_Group) %>% 
  summarise(
    Jumlah_Fasilitas=n(),
    Sampahmasuk_TonThn=sum(Sampahmasuk_TonThn),
    Sampahterkelola_TonThn=sum(Sampahterkelola_TonThn)
  ) %>% 
  ungroup() 


pengolah_lat<-left_join(pengolah_lat,distinct(lat[,c("KabupatenKota","latitude","longitude")]),by=c("KabupatenKota"="KabupatenKota") )
