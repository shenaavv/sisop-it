#!/bin/bash

DATA="reading_data.csv"

echo "Pilih nomor jawaban:"
echo "1. A) Chris Hemsworth membaca"
echo "2. B) Rata-rata durasi membaca dengan Tablet"
echo "3. C) Pembaca dengan rating tertinggi"
echo "4. D) Genre paling populer di Asia setelah 2023"
echo -n "Masukkan pilihan (1/2/3/4): "
read pilihan

# -- Pengerjaan soal A --
if [ "$pilihan" == "1" ]; then
awk -F ',' 'NR > 1 && $2 == "Chris Hemsworth" {++n}
END { print "Chris Hemsworth membaca", n, "buku." }' reading_data.csv

# -- Pengerjaan soal B --
elif [ "$pilihan" == "2" ]; then
awk -F ',' 'NR > 1 && $8 == "Tablet" { sum += $6; count++ }
END { print "Rata-rata durasi membaca dengan Tablet adalah", sum/count, "menit." }' reading_data.csv

# -- Pengerjaan soal C --
elif [ "$pilihan" == "3" ]; then
awk -F ',' 'NR > 1 && $7 > max { max = $7; name =  $2; book = $3 }
END { print "Pembaca dengan rating tertinggi: "name, "-", book, "-", max }' reading_data.csv

# -- Pengerjaan soal D --
elif [ "$pilihan" == "4" ]; then
awk -F ',' 'NR > 1 && $9 == "Asia" && $5 > "2023-12-31" { genres[$4]++ }
END {max = 0; for (genre in genres) {if (genres[genre] > max) {max = genres[genre];most_common = genre;}} print "Genre paling populer di Asia setelah 2023 adalah " most_common " dengan " max " buku."}' reading_data.csv

fi
