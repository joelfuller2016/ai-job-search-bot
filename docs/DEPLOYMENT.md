# Deployment Guide

This guide covers different deployment options for the AI Job Search Bot.

## Prerequisites

- Docker and Docker Compose (recommended)
- Node.js 18+ (for manual deployment)
- Git
- Gmail API credentials
- Claude/OpenAI API keys

## Environment Setup

### 1. Clone and Configure

```bash
git clone https://github.com/joelfuller2016/ai-job-search-bot.git
cd ai-job-search-bot
cp .env.example .env
```

### 2. Configure Environment Variables

Edit `.env` file with your configuration:

```bash
# API Keys
CLAUDE_API_KEY=your_claude_api_key
OPENAI_API_KEY=your_openai_api_key
BRAVE_API_KEY=your_brave_search_api_key

# Gmail API
GMAIL_CLIENT_ID=your_gmail_client_id
GMAIL_CLIENT_SECRET=your_gmail_client_secret

# Production settings
NODE_ENV=production
PORT=3001
DATABASE_URL=./data/jobs.db
```

## Deployment Options

### Option 1: Docker Compose (Recommended)

This is the easiest way to deploy all services together.

```bash
# Build and start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

#### Services Included:
- **API Server**: Backend API (port 3001)
- **Dashboard**: React frontend (port 3000)
- **n8n**: Workflow automation (port 5678)
- **Browser**: Headless browser for scraping (port 9222)

#### Accessing Services:
- Dashboard: http://localhost:3000
- API: http://localhost:3001
- n8n: http://localhost:5678 (admin/admin123)

### Option 2: Manual Deployment

#### Backend API

```bash
cd api
npm install
npm run build

# Setup database
npm run db:migrate

# Start production server
npm start
```

#### Frontend Dashboard

```bash
cd dashboard
npm install
npm run build

# Serve with a static server
npx serve -s build -l 3000
```

#### n8n Workflows

```bash
# Install n8n globally
npm install -g n8n

# Start n8n
n8n start

# Import workflows
# Navigate to http://localhost:5678
# Import the workflow files from n8n-workflows/
```

## Configuration

### Job Search Criteria

Edit `config/search-criteria.json` to customize:
- Keywords and job titles to search for
- Locations and remote work preferences
- Job boards to scrape
- Company whitelist/blacklist
- AI analysis criteria

### Resume Upload

Place your resume file in `assets/resume.pdf` for the system to use in applications.

## n8n Workflow Setup

1. Access n8n at http://localhost:5678
2. Login with admin/admin123
3. Import the workflow from `n8n-workflows/job-search-workflow.json`
4. Configure webhook endpoints to point to your API
5. Activate the workflow

## Usage

### Starting a Job Search

```bash
# Trigger via API
curl -X POST http://localhost:3001/api/jobs/search \
  -H "Content-Type: application/json" \
  -d '{
    "keywords": "software developer",
    "location": "Remote",
    "jobBoards": ["indeed", "linkedin"],
    "maxResults": 50
  }'
```

### Monitoring

- **Dashboard**: View job pipeline and application status
- **Logs**: Check `logs/app.log` for system logs
- **n8n**: Monitor workflow executions
- **Database**: SQLite database at `database/jobs.db`

## Troubleshooting

### Common Issues

1. **Port conflicts**
   ```bash
   sudo netstat -tlnp | grep :3001
   sudo kill -9 <PID>
   ```

2. **Database permissions**
   ```bash
   chmod 644 ./data/jobs.db
   ```

3. **Browser automation issues**
   ```bash
   # Install additional dependencies for Puppeteer
   sudo apt install -y fonts-liberation libasound2 libatk-bridge2.0-0
   ```

### Logs and Debugging

```bash
# Enable debug logging
DEBUG=* NODE_ENV=development npm start

# Check specific component logs
docker-compose logs -f api | grep ERROR
docker-compose logs -f n8n | grep workflow
```

## Security Considerations

⚠️ **Note**: As specified, security is not a primary concern for this project. However, for production use:

- Use environment variables for sensitive data
- Implement API authentication
- Set up SSL/TLS certificates
- Configure firewall rules
- Regular security updates

## Performance Optimization

### Database Optimization
- Regular VACUUM operations for SQLite
- Index optimization for frequent queries
- Consider PostgreSQL for larger datasets

### API Optimization
- Implement caching for frequently accessed data
- Use connection pooling
- Enable gzip compression

### Browser Automation
- Pool browser instances for better performance
- Use headless mode in production
- Implement retry mechanisms for failed operations

## Scaling

For high-volume job searching:

1. **Horizontal Scaling**: Deploy multiple API instances behind a load balancer
2. **Database Scaling**: Migrate to PostgreSQL with read replicas
3. **Queue System**: Implement Redis for job processing queues
4. **Monitoring**: Add Prometheus and Grafana for metrics

## Support

For issues and questions:
- Check the logs first
- Review the [API documentation](./API.md)
- Create an issue on GitHub
- Check n8n community forums for workflow help

---

*Happy job hunting! 🎯*