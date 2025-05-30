# API Documentation

## Base URL
```
http://localhost:3001/api
```

## Authentication
Currently, the API does not require authentication. In a production environment, you should implement proper authentication and authorization.

## Endpoints

### Jobs

#### GET /jobs
Retrieve a list of jobs with optional filtering.

**Query Parameters:**
- `status` (string): Filter by job status (discovered, analyzed, applied, etc.)
- `company` (string): Filter by company name (partial match)
- `location` (string): Filter by location (partial match)
- `minPriority` (number): Minimum priority score
- `maxPriority` (number): Maximum priority score
- `minMatchScore` (number): Minimum AI match score (0-1)
- `page` (number): Page number (default: 1)
- `limit` (number): Results per page (default: 20, max: 100)
- `sortBy` (string): Sort field (default: discoveredAt)
- `sortOrder` (string): Sort order (ASC, DESC)

**Response:**
```json
{
  "jobs": [
    {
      "id": 1,
      "title": "Senior Software Developer",
      "company": "Tech Company Inc",
      "location": "Remote",
      "salary": "$120,000 - $150,000",
      "description": "Job description...",
      "jobUrl": "https://example.com/job/123",
      "status": "discovered",
      "priority": 85,
      "matchScore": 0.92,
      "discoveredAt": "2024-01-15T10:30:00Z",
      "aiAnalysis": {
        "skillMatch": 0.95,
        "experienceMatch": 0.88,
        "recommendations": ["Strong technical fit", "Company culture alignment"]
      }
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 150,
    "pages": 8
  }
}
```

#### POST /jobs/search
Trigger a new job search.

**Request Body:**
```json
{
  "keywords": "software developer javascript",
  "location": "Remote",
  "jobBoards": ["indeed", "linkedin", "glassdoor"],
  "maxResults": 50
}
```

**Response:**
```json
{
  "message": "Job search initiated",
  "searchId": "1642248000000",
  "status": "in_progress",
  "estimatedCompletion": "2024-01-15T11:00:00Z"
}
```

### Applications

#### GET /applications
Retrieve a list of applications.

#### POST /applications
Create a new application.

**Request Body:**
```json
{
  "jobId": 1,
  "coverLetter": "Dear Hiring Manager...",
  "applicationMethod": "automated",
  "resumeVersion": "v2.1"
}
```

### Analytics

#### GET /analytics/dashboard
Get dashboard analytics.

**Response:**
```json
{
  "totalJobs": 150,
  "totalApplications": 45,
  "totalInterviews": 8,
  "responseRate": 35.6,
  "jobsTrend": "+12%",
  "applicationsTrend": "+8%"
}
```

## Error Responses

All endpoints return errors in the following format:

```json
{
  "error": "Error message",
  "code": "ERROR_CODE",
  "details": {
    "field": "Additional error details"
  }
}
```

**Common HTTP Status Codes:**
- `200` - Success
- `201` - Created
- `400` - Bad Request (validation errors)
- `404` - Not Found
- `500` - Internal Server Error

## Rate Limits

The API implements rate limiting to prevent abuse:
- General endpoints: 100 requests per minute
- Search endpoints: 10 requests per minute
- Heavy operations: 5 requests per minute

## JavaScript Example

```javascript
const axios = require('axios');

const api = axios.create({
  baseURL: 'http://localhost:3001/api',
  timeout: 5000
});

// Get jobs
const jobs = await api.get('/jobs?status=discovered&limit=10');

// Trigger job search
const search = await api.post('/jobs/search', {
  keywords: 'react developer',
  location: 'Remote',
  jobBoards: ['linkedin', 'indeed']
});
```