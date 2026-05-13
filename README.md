# TaskFlow - DevOps Demo Application

A simple task management web application built for demonstrating DevOps principles and CI/CD pipelines.

## Features

- ✅ Add, complete, and delete tasks
- ✅ Filter tasks (All, Active, Completed)
- ✅ Real-time statistics
- ✅ Persistent storage using localStorage
- ✅ Responsive design
- ✅ Health check endpoint
- ✅ Dockerized for easy deployment

## Technologies Used

- **Frontend**: HTML5, CSS3, JavaScript (ES6+)
- **Web Server**: Nginx (Alpine Linux)
- **Containerization**: Docker
- **Fonts**: Google Fonts (Space Mono, Work Sans)

## Local Development

### Option 1: Direct Browser

Simply open `index.html` in your web browser.

### Option 2: Local Web Server

```bash
# Using Python
python -m http.server 8080

# Using Node.js (http-server)
npx http-server -p 8080
```

Then visit: http://localhost:8080

## Docker Deployment

### Build and Run with Docker

```bash
# Build the image
docker build -t taskflow-app:1.0.0 .

# Run the container
docker run -d -p 8080:80 --name taskflow taskflow-app:1.0.0
```

### Using Docker Compose

```bash
# Start the application
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the application
docker-compose down
```

Visit: http://localhost:8080

## Health Check

The application includes a health check endpoint:

```bash
curl http://localhost:8080
```

## Application Structure

```
todo-app/
├── index.html          # Main HTML structure
├── styles.css          # Styling and design
├── app.js              # Application logic
├── Dockerfile          # Container definition
├── docker-compose.yml  # Docker Compose configuration
└── README.md           # This file
```

## Version

Current version: **1.0.0**

## License

MIT License - Created for educational/demonstration purposes
# Test change for CI/CD
# Pipeline Test

## Updated Docker credentials
