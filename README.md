# SnakeWars
***projekt na UEC2***
## Zasady gry
- gracz wygrywa gdy nie dojdzie do kolizji i zdobędzie 15 punktów
- gracz wygrywa gdy przeciwnik ulegnie kolizji
- sterowanie odbywa się za pomocą myszy i lewy przycisk oznacza skręt w lewo a prawy, w prawo

## Praca z repo
Sugeruję aby na każdą z głównych części 0,1,2 itp istniał osobny branch na którym będą wrzucane zmiany, mergować z masterem będziemy gdy jakaś część zostanie ukończona.

- Najpierw pobieramy repozytorium:
```
git clone https://github.com/HalmonCelman/SnakeWars
```
- Wchodzimy do folderu i patrzymy na listę obecnie istniejących branchy:
```
git branch
```
- Jeśli nie ma brancha na którym chcemy pracować(np 0_preparation) to go tworzymy:
```
git branch 0_preparation
```
- Przełączamy się na niego i jeśli istniał wcześniej to ściągamy zmiany
```
git checkout 0_preparation
git pull
```
- normalnie pracujemy, modyfikujemy pliki, następnie dodajemy zmiany, commitujemy i pushujemy
```
git add .
git commit
git push
```

- oczywiście w dowolnym momencie możemy uruchomić `git status` aby dowiedzieć się czy przesyłamy to co chcemy

## Praca z projektem
- na początek zawsze:
```
. env.sh
```
lub
```
. ./env.sh
``` 
- uruchomienie symulacji tekstowo
```
run_simulation -t <nazwa symulacji>
```
- uruchomienie symulacji graficznie
```
run_simulation -gt <nazwa symulacji>
```
- generacja bitstreamu
```
generate_bitstream
```
- zaprogramowanie fpga wygenerowanym bitstreamem
```
program_fpga
```