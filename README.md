# Duelo de Feitiços

**Reconhecimento de símbolos desenhados no ar com redes neurais LSTM**

Jogo interativo em que o jogador lança feitiços desenhando símbolos no ar em frente à webcam. A posição do dedo é detectada pelo MediaPipe Hands e cada desenho é classificado em tempo real por uma rede neural recorrente **LSTM** treinada com um dataset próprio.

Projeto da disciplina **Redes Neurais** (Prof. Sandro Silva Moreira), apresentado no 5º Workshop de Trabalhos de Inteligência Artificial – FASOFT / UniRV, 2026.

**Autora:** Maria Eduarda Goetz Maia

---

## Como funciona

```
Webcam → MediaPipe Hands → ponta do indicador → traço
      → 32 pontos (x, y, dx, dy) → LSTM → feitiço
```

| Símbolo     | Feitiço      |
|-------------|--------------|
| Zigue-zague | Raio         |
| Círculo     | Bola de fogo |
| Triângulo   | Terremoto    |
| V           | Gelo         |
| Onda        | Tsunami      |

### Arquitetura da rede

| Camada  | Configuração                       | Parâmetros |
|---------|------------------------------------|-----------:|
| Entrada | 32 passos × 4 (x, y, dx, dy)       |          – |
| LSTM    | 48 unidades (retorna sequência)    |     10.176 |
| Dropout | 20%                                |          – |
| LSTM    | 24 unidades                        |      7.008 |
| Densa   | 24 unidades, ReLU                  |        600 |
| Saída   | 5 unidades, Softmax                |        125 |
| **Total** |                                  | **17.909** |

Treino: Adam (lr 0,003), entropia cruzada categórica, lotes de 32, até 60 épocas com parada antecipada, divisão 80/20 e data augmentation (rotação, escala e ruído).

### Resultados

- Dataset próprio: 200 sequências (40 por símbolo)
- **Acurácia na validação: 92,5%** (18 épocas, 44 s de treino em CPU)

## Tecnologias

- HTML5, JavaScript e Canvas 2D
- [TensorFlow.js](https://www.tensorflow.org/js) 4.20.0 com backend WebAssembly
- [MediaPipe Tasks Vision](https://developers.google.com/mediapipe) 0.10.14 (Hand Landmarker)
- Python (`http.server`) apenas para servir os arquivos localmente

## Como executar (Windows)

Requisitos: Python 3 instalado e navegador Google Chrome.

1. Baixe ou clone este repositório.
2. Dê um duplo clique em **`INICIAR.bat`**.
   - Na primeira execução, com internet, ele baixa o modelo de detecção da mão para a pasta `modelo/`.
   - Depois disso, o jogo funciona **sem internet**.
3. O jogo abre em `http://localhost:8000`. Clique em **Ligar câmera**.

Para desenhar: aponte o dedo indicador (com os dedos médio e anelar dobrados), faça o símbolo no ar e abra a mão para terminar. O mouse também funciona.

## Etapas na aplicação

1. **Coleta de dados:** grave exemplos de cada símbolo (sugestão: 40 por símbolo).
2. **Treinar LSTM:** treine a rede e acompanhe as curvas de perda/acurácia e a matriz de confusão.
3. **Testar:** veja a sequência de entrada e a probabilidade de cada símbolo.
4. **Jogar:** derrote os monstros desenhando o símbolo mostrado sobre cada um.

O dataset e o modelo ficam salvos no navegador. Use **Exportar dados** para fazer backup do dataset em JSON.

## Estrutura

```
duelo_feiticos/
├── index.html        aplicação completa (coleta, treino, teste e jogo)
├── INICIAR.bat       inicia o servidor local e abre o jogo
├── LEIA-ME.txt       instruções rápidas
├── lib/              TensorFlow.js e MediaPipe (uso offline)
└── modelo/           modelo de detecção da mão (baixado na primeira execução)
```

## Referências

- HOCHREITER, S.; SCHMIDHUBER, J. Long short-term memory. *Neural Computation*, v. 9, n. 8, p. 1735-1780, 1997.
- ZHANG, F. et al. MediaPipe Hands: on-device real-time hand tracking. arXiv:2006.10214, 2020.
- SMILKOV, D. et al. TensorFlow.js: machine learning for the web and beyond. arXiv:1901.05350, 2019.
