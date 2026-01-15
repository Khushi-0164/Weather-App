# Weather App Deployment Guide

## ✅ Build Complete
Your application has been successfully built! The JAR file is located at:
`target/Weather-App-0.0.1-SNAPSHOT.jar`

---

## 🐳 Docker Deployment (Recommended)

### Build and Run with Docker

```bash
# Build the Docker image
docker build -t weather-app:latest .

# Run with environment variable
docker run -p 8080:8080 \
  -e WEATHER_API_KEY=your_api_key_here \
  weather-app:latest
```

Access your app at: **http://localhost:8080**

---

## 📦 Local JAR Deployment

### Run the JAR file directly

```bash
# With environment variable (recommended)
export WEATHER_API_KEY=your_api_key_here
java -jar target/Weather-App-0.0.1-SNAPSHOT.jar

# Or inline
java -jar -DWEATHER_API_KEY=your_api_key_here target/Weather-App-0.0.1-SNAPSHOT.jar
```

---

## ☁️ Cloud Platform Deployment

### 1. **Heroku**

```bash
# Install Heroku CLI first
heroku login
heroku create your-weather-app-name

# Set environment variable
heroku config:set WEATHER_API_KEY=your_api_key_here

# Add Procfile (already created below)
git add .
git commit -m "Prepare for Heroku"
git push heroku main
```

### 2. **Railway.app**

1. Visit https://railway.app
2. Click "New Project" → "Deploy from GitHub"
3. Select your repository
4. Add environment variable:
   - Key: `WEATHER_API_KEY`
   - Value: `your_api_key_here`
5. Deploy automatically!

### 3. **Render.com**

1. Visit https://render.com
2. Click "New Web Service"
3. Connect your GitHub repository
4. Configure:
   - **Build Command**: `mvn clean package -DskipTests`
   - **Start Command**: `java -jar target/Weather-App-0.0.1-SNAPSHOT.jar`
5. Add environment variable:
   - Key: `WEATHER_API_KEY`
   - Value: `your_api_key_here`

### 4. **AWS Elastic Beanstalk**

```bash
# Install EB CLI
pip install awsebcli

# Initialize
eb init -p java-17 weather-app --region us-east-1

# Create environment
eb create weather-app-env

# Set environment variable
eb setenv WEATHER_API_KEY=your_api_key_here

# Deploy
eb deploy
```

### 5. **Google Cloud Run**

```bash
# Build and push to Container Registry
gcloud builds submit --tag gcr.io/YOUR_PROJECT_ID/weather-app

# Deploy
gcloud run deploy weather-app \
  --image gcr.io/YOUR_PROJECT_ID/weather-app \
  --platform managed \
  --region us-central1 \
  --set-env-vars WEATHER_API_KEY=your_api_key_here \
  --allow-unauthenticated
```

### 6. **Azure App Service**

```bash
# Login
az login

# Create resource group
az group create --name WeatherAppRG --location eastus

# Create App Service plan
az appservice plan create --name WeatherAppPlan \
  --resource-group WeatherAppRG --sku B1 --is-linux

# Create web app
az webapp create --resource-group WeatherAppRG \
  --plan WeatherAppPlan --name your-weather-app \
  --runtime "JAVA:17-java17"

# Set environment variable
az webapp config appsettings set --resource-group WeatherAppRG \
  --name your-weather-app \
  --settings WEATHER_API_KEY=your_api_key_here

# Deploy JAR
az webapp deploy --resource-group WeatherAppRG \
  --name your-weather-app \
  --src-path target/Weather-App-0.0.1-SNAPSHOT.jar
```

---

## 🔐 Security Best Practices

### Environment Variables
Always use environment variables for sensitive data:

**Linux/macOS:**
```bash
export WEATHER_API_KEY=your_api_key_here
```

**Windows:**
```cmd
set WEATHER_API_KEY=your_api_key_here
```

### .gitignore
Make sure these are in your `.gitignore`:
```
application.properties
*.env
.env.local
```

---

## 🧪 Test Your Deployment

Once deployed, test these endpoints:

```bash
# Health check
curl http://your-app-url/actuator/health

# Get current weather
curl "http://your-app-url/weather/current?city=London"

# Get forecast
curl "http://your-app-url/weather/forecast?city=Paris&days=3"
```

---

## 📱 Frontend Integration

The UI files are in the `UI/` folder. To deploy the frontend:

1. **Static hosting** (Netlify, Vercel, GitHub Pages):
   - Upload `UI/index.html`, `UI/script.js`, `UI/styles.css`
   - Update API URL in `script.js` to your deployed backend URL

2. **With backend** (serve from Spring Boot):
   - Move UI files to `src/main/resources/static/`
   - Rebuild and deploy

---

## 🚨 Troubleshooting

**Issue**: Port already in use
```bash
# Find and kill process on port 8080
lsof -ti:8080 | xargs kill -9
```

**Issue**: Docker build fails
```bash
# Clean rebuild
mvn clean
docker system prune -a
docker build --no-cache -t weather-app:latest .
```

**Issue**: API key not working
```bash
# Verify environment variable is set
echo $WEATHER_API_KEY

# Check application logs
docker logs <container-id>
```

---

## 📊 Monitoring

Add Spring Boot Actuator for monitoring (already included):

Access metrics at:
- `/actuator/health` - Health status
- `/actuator/metrics` - Application metrics
- `/actuator/info` - Application info

---

## 🔄 Continuous Deployment

### GitHub Actions Example
Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Cloud

on:
  push:
    branches: [main]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Set up JDK 17
      uses: actions/setup-java@v2
      with:
        java-version: '17'
        distribution: 'adopt'
    
    - name: Build with Maven
      run: mvn clean package -DskipTests
    
    - name: Build Docker image
      run: docker build -t weather-app .
    
    # Add your deployment steps here
```

---

## 📝 Notes

- Default port: **8080**
- Java version: **17**
- Spring Boot version: **3.2.4**
- API Key is now secured with environment variables
- The fallback API key will be used if WEATHER_API_KEY is not set

**Ready to deploy! Choose your preferred platform from the options above.** 🚀
