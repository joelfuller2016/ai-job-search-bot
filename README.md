# AI Job Search & Application Bot

A comprehensive automated job search and application system powered by AI, web scraping, and workflow automation.

## 🚀 Features

- **Automated Job Discovery**: Searches multiple job boards and company websites
- **AI-Powered Analysis**: Uses Claude/OpenAI to understand job requirements and match with skills
- **Smart Application**: Automatically applies to relevant positions with tailored cover letters
- **Database Management**: Persistent storage for job data, applications, and tracking
- **Email Automation**: Creates Gmail accounts, manages correspondence, and schedules interviews
- **Self-Healing**: AI-powered error detection and resolution
- **Dashboard Interface**: Easy-to-use web interface for monitoring and management

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Web Scraper   │    │   AI Analyzer   │    │   Application   │
│   (Puppeteer)   │───▶│   (Claude API)  │───▶│     Engine      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Job Database  │    │   Email Manager │    │   n8n Workflows │
│   (SQLite)      │    │   (Gmail API)   │    │   (Orchestration)│
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 ▼
                    ┌─────────────────┐
                    │  Dashboard UI   │
                    │   (React)       │
                    └─────────────────┘
```

## 🛠️ Technology Stack

- **Orchestration**: n8n for workflow automation
- **Web Automation**: Puppeteer for browser interactions
- **AI**: Claude API for job analysis and application generation
- **Database**: SQLite for data persistence
- **Email**: Gmail API for account management
- **Search**: Brave Search API for job discovery
- **Frontend**: React.js dashboard
- **Backend**: Node.js API server
- **Deployment**: Docker containers

## 📁 Project Structure

```
ai-job-search-bot/
├── api/                     # Backend API server
│   ├── controllers/         # API route handlers
│   ├── models/             # Database models
│   ├── services/           # Business logic
│   └── server.js           # Express server
├── dashboard/              # React frontend
│   ├── src/
│   ├── public/
│   └── package.json
├── database/               # Database schema and migrations
├── n8n-workflows/          # Workflow definitions
├── scrapers/               # Web scraping modules
├── ai-engine/              # AI analysis and generation
├── email-manager/          # Gmail automation
├── config/                 # Configuration files
├── docker/                 # Docker configurations
├── docs/                   # Documentation
└── scripts/                # Utility scripts
```

## 🚀 Quick Start

### Prerequisites

- Node.js 18+
- Docker (optional)
- Gmail API credentials
- Claude/OpenAI API keys

### Installation

```bash
# Clone the repository
git clone https://github.com/joelfuller2016/ai-job-search-bot.git
cd ai-job-search-bot

# Install dependencies
npm run install:all

# Setup environment variables
cp .env.example .env
# Edit .env with your API keys and configuration

# Initialize database
npm run db:setup

# Start all services
npm run dev
```

### Docker Setup (Recommended)

```bash
# Build and start all services
docker-compose up -d

# Access the dashboard
open http://localhost:3000
```

## 📋 Configuration

1. **API Keys**: Configure in `.env` file
   - `CLAUDE_API_KEY`: Claude API for AI analysis
   - `GMAIL_CLIENT_ID`: Gmail API credentials
   - `BRAVE_API_KEY`: For web search

2. **Job Search Criteria**: Configure in `config/search-criteria.json`
   - Keywords, locations, salary ranges
   - Company preferences and blacklists

3. **Resume**: Upload your resume in `assets/resume.pdf`

## 🔄 Workflows

### 1. Job Discovery Workflow
- Searches job boards (Indeed, LinkedIn, Glassdoor, etc.)
- Discovers new company career pages
- Filters jobs based on criteria
- Stores in database

### 2. Job Analysis Workflow
- AI analyzes job requirements
- Matches with user skills and resume
- Generates application priority score
- Creates tailored cover letters

### 3. Application Workflow
- Automatically applies to high-priority jobs
- Handles form filling and document uploads
- Tracks application status
- Manages follow-ups

### 4. Email Management Workflow
- Creates dedicated Gmail accounts
- Monitors for responses
- Schedules interviews
- Sends follow-up emails

### 5. Error Recovery Workflow
- Monitors for failures
- Uses AI to diagnose issues
- Implements automatic fixes
- Escalates complex problems

## 📊 Dashboard Features

- **Job Pipeline**: View discovered, analyzed, and applied jobs
- **Application Tracking**: Monitor application statuses
- **Interview Calendar**: Schedule and manage interviews
- **Analytics**: Success rates, response times, etc.
- **Settings**: Configure search criteria and preferences

## 🔧 API Endpoints

```
GET    /api/jobs              # List all jobs
POST   /api/jobs/search       # Trigger job search
GET    /api/applications      # List applications
POST   /api/applications      # Create application
GET    /api/interviews        # List interviews
POST   /api/interviews        # Schedule interview
GET    /api/analytics         # Get analytics data
```

## 🧪 Testing

```bash
# Run unit tests
npm test

# Run integration tests
npm run test:integration

# Run end-to-end tests
npm run test:e2e
```

## 📈 Monitoring

- **Logs**: Structured logging with Winston
- **Metrics**: Performance and success rate tracking
- **Alerts**: Email notifications for critical issues
- **Health Checks**: Endpoint monitoring

## 🔒 Security Considerations

⚠️ **Note**: As specified, security is not a primary concern for this project. However, consider these points for production use:

- Secure API key storage
- Rate limiting for external APIs
- Data encryption for sensitive information
- Access controls for the dashboard

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🆘 Support

For issues and questions:
- Create an [Issue](https://github.com/joelfuller2016/ai-job-search-bot/issues)
- Check the [Documentation](docs/)
- Review [FAQ](docs/FAQ.md)

## 🔄 Roadmap

- [ ] Multi-language support
- [ ] Advanced AI filtering
- [ ] Mobile app
- [ ] Integration with more job boards
- [ ] Salary negotiation automation
- [ ] Skills gap analysis
- [ ] Interview preparation assistance

---

*Built with ❤️ for job seekers worldwide*