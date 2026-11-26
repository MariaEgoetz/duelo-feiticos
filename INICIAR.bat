@echo off
title Duelo de Feiticos
cd /d "%~dp0"

if not exist "modelo\hand_landmarker.task" (
  echo Baixando o modelo de deteccao da mao - so na primeira vez, precisa de internet...
  powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://storage.googleapis.com/mediapipe-models/hand_landmarker/hand_landmarker/float16/1/hand_landmarker.task' -OutFile 'modelo\hand_landmarker.task'"
  if not exist "modelo\hand_landmarker.task" (
    echo.
    echo Nao consegui baixar o modelo. Conecte a internet e rode de novo.
    echo O jogo vai abrir mesmo assim, mas so com o mouse.
    echo.
    pause
  ) else (
    echo Modelo baixado! Agora o jogo funciona sem internet.
  )
)

where py >nul 2>nul && (set PY=py) || (set PY=python)
echo.
echo Abrindo o jogo em http://localhost:8000
echo Para fechar o jogo, feche esta janela.
echo.
start "" cmd /c "timeout /t 2 >nul & start http://localhost:8000"
%PY% -m http.server 8000 --bind 127.0.0.1
