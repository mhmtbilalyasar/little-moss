# Little Moss (Godot 4.7 - mobil platform oyunu, iskelet surumu)

## Nasil acarim?
1. Zip'i bir klasore cikar (ornegin Masaustu/little-moss).
2. Godot'u ac -> "Import" (Iceri aktar) -> cikardigin klasordeki `project.godot` dosyasini sec.
3. Ilk acilista Godot resimleri otomatik "import" eder, 10-20 saniye surebilir. Bekle.
4. Sag ustteki "Play" (▶) tusuna bas (F5). Oyun Level 1'den baslar.

Bilgisayarda: ok tuslari = sag/sol, Bosluk (Space) = zipla. Ekrandaki butonlara fareyle de tiklayabilirsin.

## Klasorler
- `art/`      Gecici resimler (hepsi 16x16 piksel). Kendi cizimini AYNI ISIMLE bu klasore atinca oyun onu kullanir.
- `tiles/`    meadow_tiles.tres = zemin kalip seti (resmi art/tiles.png).
- `scenes/`   Oyundaki parcalar: player, crawler (bocek), spike (diken), checkpoint, mushroom, glow_seed, exit, sign, hud (canlar + dokunmatik butonlar), background.
- `levels/`   Bolumler (level_1, level_2, level_3). Hepsi Godot editorunde acilip cizilebilir.
- `scripts/`  Cok kisa kodlar (hepsi toplam ~200 satir).

## Bolum nasil cizilir? (kod yok)
1. `levels/level_1.tscn` dosyasini cift tikla.
2. Soldaki "Scene" panelinde `Ground` dugumunu sec. Altta "TileMap" paneli acilir.
3. Soldan bir kalip (cimen, toprak, kopru) sec ve sahneye boya. Silmek icin sag tik.
4. Dusman, diken, checkpoint, tohum eklemek icin `scenes/` klasorunden sahneye surukle-birak yap. Kendi parçani `Things` dugumunun altina birak.
5. Kaydet (Ctrl+S) ve Play ile dene.

## Sayilari ayarlamak
Sahnede `Player` dugumunu sec, sag paneldeki Inspector'da hiz, ziplama gucu, yercekimi, can sayisi gibi degerleri degistirebilirsin.

## Su an olanlar
Level 1-3 oynanabilir. Zorluk ve hareket hissi eski surumdeki ayarlarla ayni.
Var: yuruyus/ziplama (coyote time, jump buffer, kisa ziplama), 3 can, diken, checkpoint, ziplatan mantar, tohum, cikis, Crawler bocek (ustune basarak yenilir), dokunmatik butonlar, yatay ekran.

## Henuz yok (siradaki adimlar)
Ana menu, ayarlar, bolum secme ekrani, kayit sistemi, ses/muzik, Level 4-6 (hareketli ve cokan platform, Charger), Spitter, Android'e cikis.
