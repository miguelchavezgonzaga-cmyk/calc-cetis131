# Calculadora Científica CETIS 131
**Autor:** Miguel Alejandro Chavez Gonzaga  
**Institución:** CETIS 131  
**Plataforma:** Flutter / iOS

---

## ¿Qué incluye?

- Splash screen con logo CETIS 131 + nombre del autor
- Calculadora científica completa:
  - Operaciones básicas: +, −, ×, ÷
  - Trigonometría: sin, cos, tan + inversas (2nd)
  - Hiperbólicas: sinh, cosh, tanh
  - Logaritmos: log, ln, log₂ + inversas (2nd)
  - Potencias: x², x³, yˣ, 10ˣ, eˣ, 2ˣ
  - Raíces: √, ∛, ˣ√y
  - Factorial, 1/x, abs, %
  - Constantes: π, e
  - Aleatorio: Rand
  - Memoria: MC, MR, M+, M−, MS
  - Toggle DEG / RAD
  - Toggle 2nd (funciones inversas)
  - Modo landscape automático

---

## Cómo compilar el IPA con Codemagic (GRATIS)

### Paso 1 – Sube el proyecto a GitHub
```bash
git init
git add .
git commit -m "Calculadora Científica CETIS 131"
git remote add origin https://github.com/TU_USUARIO/calc-cetis131.git
git push -u origin main
```

### Paso 2 – Conecta en Codemagic
1. Ve a https://codemagic.io y crea cuenta (gratis)
2. Clic en **"Add application"**
3. Conecta tu cuenta de GitHub y selecciona el repo
4. Selecciona **"Flutter App"**
5. En la pestaña **"Configuration"** elige **"codemagic.yaml"**
6. Clic en **"Start build"**

### Paso 3 – Descarga el IPA
- Al terminar el build (~10–15 min) descarga el `.ipa` desde **Artifacts**
- Sin Apple Developer Account: el IPA es sin firmar (válido para demostración)
- Con cuenta ($99/año): puedes firmarlo y distribúirlo

---

## Correr localmente (si tienes Mac con Xcode)
```bash
flutter pub get
flutter run -d "iPhone 15 Simulator"
```
