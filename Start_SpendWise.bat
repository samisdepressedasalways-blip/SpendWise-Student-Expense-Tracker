@echo off
setlocal
set "ROOT=%~dp0"

echo ==========================================
echo        SpendWise - Starting all services
echo ==========================================
echo.
echo Keep the three service windows open.
echo.

if not exist "%ROOT%backend\package.json" (
  echo ERROR: Could not find the backend folder.
  echo Put this .bat file inside the main expense-tracker folder.
  pause
  exit /b 1
)

if not exist "%ROOT%frontend\package.json" (
  echo ERROR: Could not find the frontend folder.
  echo Put this .bat file inside the main expense-tracker folder.
  pause
  exit /b 1
)

if not exist "%ROOT%fastapi-service\main.py" (
  echo ERROR: Could not find the fastapi-service folder.
  pause
  exit /b 1
)

if not exist "%ROOT%fastapi-service\.venv\Scripts\activate.bat" (
  echo ERROR: Python environment not found.
  echo In VS Code terminal, go to fastapi-service and run:
  echo python -m venv .venv
  echo .venv\Scripts\activate
  echo pip install -r requirements.txt
  pause
  exit /b 1
)

start "SpendWise Backend - port 5000" cmd /k "cd /d ""%ROOT%backend"" && npm run dev"
start "SpendWise Frontend - port 5173" cmd /k "cd /d ""%ROOT%frontend"" && npm run dev"
start "SpendWise FastAPI - port 8000" cmd /k "cd /d ""%ROOT%fastapi-service"" && call .venv\Scripts\activate.bat && uvicorn main:app --reload --port 8000"

echo.
echo Startup commands sent to three new windows.
echo Wait until the backend says Connected to MongoDB,
echo the frontend shows its Local URL, and FastAPI says
echo Application startup complete.
echo.
echo App:       http://localhost:5173
echo API docs:  http://127.0.0.1:8000/docs
echo.
echo NOTE: MongoDB Server must already be running.
pause
