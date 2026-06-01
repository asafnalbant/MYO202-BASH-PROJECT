#!/bin/bash
# Ahmet Asaf Nalbant
# 2420171035
# Sertifikalar:
# 1. https://www.btkakademi.gov.tr/portal/certificate/validate?certificateId=/OKMhw1WX4r
# 2. https://www.btkakademi.gov.tr/portal/certificate/validate?certificateId=/0Koh8e0Ggd
# 3. https://credsverse.com/credentials/c26b662a-3b2a-4a7e-b338-c04725e694ed

REPORT="report.log"

# 1. ISO formatında tarih ve saat
echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" > "$REPORT"

# 2. Donanım bilgileri
echo "--- Donanim Bilgileri ---" >> "$REPORT"
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    wmic cpu get name >> "$REPORT"
    wmic memorychip get capacity >> "$REPORT"
    wmic baseboard get product >> "$REPORT"
    wmic diskdrive get serialnumber >> "$REPORT"
    getmac >> "$REPORT"
else
    system_profiler SPHardwareDataType >> "$REPORT"
    ifconfig >> "$REPORT"
fi

# 3. Parola alma (Burada sabit tanım yapmıyoruz, kullanıcıdan geleni alıyoruz)
echo -n "Lutfen parolayi girin: "
read -s PAROLA

# 4. GPG ile şifreleme (Kullanıcıdan alınan PAROLA değişkeni ile)
echo "$PAROLA" | gpg --batch --yes --passphrase-fd 0 -c "$REPORT"

# 5. Orijinal dosyayı sil (Güvenlik gereği)
rm "$REPORT"
