# TODO lista
***kiedy wykonamy dany punkt należy to zaznaczyć dając X w nawiasie - dzięki temu będziemy widzieć co już jest a co zostało do zrobienia***
## Część 0 - przygotowanie
- ( ) wybrać i wygenerować zegar pasujący do vga zgodnie z ["tą stroną"](http://martin.hinner.info/vga/timing.html) - proponuje 75MHz
- ( ) dostosować vga do nowej częstotliwości
- ( ) dostosować mysz do nowej częstotliwości
- ( ) dostosować uart do nowej częstotliwości
- ( ) stworzyć interfejs mapy
- ( ) stworzyć interfejs snake'a

## Część 1 - rysowanie - maszyna stanów
- ( ) rysowanie menu
- ( ) rysowanie ekranu błędu
- ( ) rysowanie ekranu końcowego
- ( ) rysowanie mapy, punktu oraz ilości puktów graczy 

## Część 2 - sterowanie
- ( ) sprawdzić działanie myszy( przycisk prawy i lewy - reszta jest zbędna na razie)
- ( ) utworzyć wrapper - z wyjściem **direction** określającym w którą stronę snake się porusza

## Część 3 - komunikacja
- ( ) sprawdzić działanie uarta (wysyłanie i odbieranie)
- ( ) napisać FSM odbierający kierunek snake'a przeciwnika i wysyłający kierunek snake'a gracza
- ( ) dodać do FSM komunikację w menu - czy gracz się połączył
- ( ) dodać funkcjonalność, że jak przyjdzie informacja o kolizji to zostanie wysłana do drugiego gracza
- ( ) jeśli przyjdzie informacja o kolizji drugiego gracza to dać znać modułowi rysującemu o ekranie zwycięstwa

## Część 4 - generacja punktu
- ( ) stworzyć generator liczb losowych
- ( ) dostosować aby zwracał x i y punktu na mapie kiedy dostanie sygnał eaten

## Część 5 - kolizje i ruch
- ( ) stworzyć dzielnik zegara który da zegar co pół sekundy
- ( ) dodać poruszanie snakiem po mapie - przyjmuje direction, wygenerowany powyżej zegar i mapę - oddaje mapę do modułu rysującego
- ( ) dodać warunki odnośnie ruchu - jeśli ma się ruszyć w miejsce zabronione to wysłać informację o kolizji
- ( ) dodać warunek odnośnie kolizji z punktem - informacja point