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

## Karakter animasyonunu kendi cizimlerinle degistirmek
`art/player_sheet.png` bir tablo: her kare 16x16 piksel. Satirlar: 1) bekleme (4 kare), 2) kosma (6 kare), 3) ziplama, 4) dusme, 5) hasar.
Kendi tablonu AYNI duzende cizip ayni isimle uzerine yazarsan animasyonlar otomatik degisir.
Kare sayisini degistirmek istersen `art/player_frames.tres` dosyasini cift tikla, alttaki "SpriteFrames" panelinde kare ekle/cikar.

## Arka plan (katmanlar)
`scenes/background.tscn` dosyasinda 5 katman var: gokyuzu (`bg_sky.png`), uc agac katmani (`bg_trees_far/mid/near.png`, kamera hareket edince farkli hizlarda kayar), gunes isiklari (`bg_rays_a/b.png`) ve havada ucusan toz parcaciklari.
Kendi cizimini AYNI ISIMLE `art/` klasorune atarsan degisir. Agac katmanlari 512x290 piksel, saga-sola kesintisiz tekrar edecek sekilde cizilmeli. Isiklarin parlama hizini `RaysA` / `RaysB` dugumlerini secip Inspector'dan ayarlayabilirsin.

## Sayilari ayarlamak
Sahnede `Player` dugumunu sec, sag paneldeki Inspector'da hiz, ziplama gucu, yercekimi, can sayisi gibi degerleri degistirebilirsin.

## Su an olanlar
Ana menu, 5 temali bolum secimi (1. tema: 20 bolum) ve Level 1-20 oynanabilir (Level 6'nin cikisi simdilik Level 1'e doner). Zorluk ve hareket hissi eski surumdeki ayarlarla ayni.
Var: karakter animasyonlari (bekleme, kosma, ziplama, dusme, hasar), hareketli ve cokan platformlar, Charger bocegi, yuruyus/ziplama (coyote time, jump buffer, kisa ziplama), 3 can, diken, checkpoint, ziplatan mantar, tohum, cikis, Crawler bocek (ustune basarak yenilir), dokunmatik butonlar, yatay ekran.

## Henuz yok (siradaki adimlar)
Bolum secme ekrani, duraklatma menusu, kayit sistemi, ses/muzik, Spitter, Android'e cikis.
