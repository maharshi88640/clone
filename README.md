# SkillXchange Platform
#video link- https://youtu.be/cwbEqvSOSlQ?si=tBIVTZ3Fyx_zA_v0
A comprehensive skill exchange platform that enables users to list their skills, request others in return, and manage skill swaps with a complete admin panel.

## Features

### User Features
- **Profile Management**: Name, location, profile photo, availability settings
- **Skills Management**: List skills offered and wanted with categories and levels
- **Privacy Controls**: Public/private profile visibility
- **Skill Discovery**: Browse and search users by skills, categories, and levels
- **Swap Requests**: Send, accept, reject, and manage skill exchange requests
- **Ratings & Feedback**: Rate and provide feedback after completed swaps
- **Request Management**: Delete pending swap requests

### Admin Features
- **User Management**: View, monitor, and ban users who violate policies
- **Swap Monitoring**: Track pending, accepted, completed, and cancelled swaps
- **Content Moderation**: Review and reject inappropriate skill descriptions
- **Platform Messaging**: Send platform-wide announcements and updates
- **Analytics Dashboard**: Monitor user activity, swap statistics, and platform health

## Technology Stack

### Frontend
- **React 18** with TypeScript
- **Tailwind CSS** for styling
- **Lucide React** for icons
- **Vite** for development and building

### Backend
- **Supabase** for backend services
- **Supabase Database** (PostgreSQL)
- **Supabase Auth** for authentication
- **Row Level Security** for data protection

## Setup Instructions

### Prerequisites
- Node.js (v16 or higher)
- Supabase account
- npm or yarn

### Supabase Setup

1. Create a new Supabase project at [supabase.com](https://supabase.com)
2. Click "Connect to Supabase" button in the top right of the application
3. The database migrations will be automatically applied

### Environment Configuration

1. Copy the environment example file:
```bash
cp .env.example .env
```

2. Update the `.env` file with your Supabase credentials:
```env
VITE_SUPABASE_URL=your_supabase_project_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

### Installation

1. Install dependencies:
```bash
npm install
```

2. Start the development server:
```bash
npm run dev
```

The application will be available at:
- Frontend: http://localhost:5173
- Backend: Supabase (serverless)

## Default Login Credentials

### Admin Account
- Email: `admin@skillxchange.com`
- Password: `admin123`

### Demo User Accounts
- Email: `sarah@example.com` / Password: `demo123`
- Email: `mike@example.com` / Password: `demo123`
- Email: `emma@example.com` / Password: `demo123`

## Database Schema

The application uses the following main tables:
- `users` - User accounts and profiles
- `skills` - Skills offered and wanted by users
- `swap_requests` - Skill exchange requests
- `ratings` - User ratings and feedback
- `admin_messages` - Platform-wide messages

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.
