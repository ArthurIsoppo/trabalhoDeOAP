// Ackermann in C++

#include <iostream>
using namespace std;

// Função de Ackermann
int A(int m, int n) {
    if (m == 0) {
        return (n + 1);
    } else if (n == 0) {
        return A((m - 1), 1) + 1;
    } else {
        return A((m - 1), A(m, (n -1)));
    }
}

// Função main
int main() {
    // Introdução
    cout << "Variante da Função de Ackermann - 31/01/2025" << endl;
    cout << "Autores: Arthur Isoppo, Carlos Eduardo Lopes, Pedro Ferraz" << endl;

    // Inicio de feto
    cout << "Digite os parâmetros m e n para calcular A(m, n) ou número negativo para abortar a execução." << endl;

    int m = 0, n = 0;
    while (true) {
        cout << "m: ";
        cin >> m;
        if (m < 0) break;

        cout << "n: ";
        cin >> n;
        if (n < 0) break;

        cout << "A(" << m << "," << n << ") = " << A(m, n) << endl;
    }
    cout << "Programa finalizado porque algum número negativo foi inserido" << endl;
}