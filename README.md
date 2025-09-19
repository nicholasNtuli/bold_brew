# Bold Brew ☕

A modern e-commerce platform built with Ruby on Rails 8, featuring a complete shopping cart system, user authentication, admin panel, and Stripe payment integration.

## 🚀 Features

### Customer Features
- **Product Browsing**: Browse products by categories with search functionality
- **Shopping Cart**: Persistent cart functionality for both guest and authenticated users
- **User Authentication**: Sign up, sign in, password recovery with Devise
- **User Profiles**: Customizable profiles with avatar cropping functionality
- **Order Management**: View order history, track order status, cancel orders
- **Stripe Checkout**: Secure payment processing with Stripe
- **Responsive Design**: Mobile-first design with Tailwind CSS

### Admin Features
- **Product Management**: Create, edit, delete products with image uploads
- **Category Management**: Organize products into categories
- **Order Management**: View, update order status, mark as paid/shipped
- **User Management**: Admin panel for user administration
- **Analytics**: Order tracking and management dashboard

### Technical Features
- **Smart Cart Transfer**: Guest carts automatically transfer to user accounts upon login
- **Image Processing**: Cloudinary integration for optimized image storage and delivery
- **Search**: Full-text search across products
- **SEO Friendly**: Friendly URLs for products and categories
- **Security**: CSRF protection, secure authentication, input validation

## 🛠️ Tech Stack

- **Backend**: Ruby 3.4.5, Rails 8.0.2.1
- **Database**: PostgreSQL
- **Authentication**: Devise
- **Payments**: Stripe
- **File Storage**: Cloudinary
- **Styling**: Tailwind CSS
- **JavaScript**: Stimulus, Turbo
- **Background Jobs**: Solid Queue
- **Caching**: Solid Cache
- **Deployment**: Render (configured)

## 📋 Prerequisites

- Ruby 3.4.5 or higher
- PostgreSQL 12 or higher
- Node.js 16 or higher
- Yarn or npm

## ⚡ Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/bold_brew.git
cd bold_brew
```

### 2. Install Dependencies
```bash
# Install Ruby gems
bundle install

# Install JavaScript packages
yarn install
# or
npm install
```

### 3. Environment Setup
Create a `.env` file in the root directory:

```env
# Database
DATABASE_URL=postgresql://username:password@localhost/bold_brew_development

# Stripe (Get from https://dashboard.stripe.com/apikeys)
STRIPE_PUBLISHABLE_KEY=pk_test_your_publishable_key
STRIPE_SECRET_KEY=sk_test_your_secret_key

# Cloudinary (Get from https://cloudinary.com/console)
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret

# Seed key for production seeding (set any secure string)
SEED_KEY=your_secure_seed_key
```

### 4. Database Setup
```bash
# Create and setup database
rails db:create
rails db:migrate

# Optional: Seed with sample data
rails db:seed
```

### 5. Start the Application
```bash
# Start Rails server
rails server

# In another terminal, start Tailwind CSS compilation (if in development)
rails tailwindcss:watch
```

Visit `http://localhost:3000` to access the application.

## 👤 Default Admin Account

After seeding, you can access the admin panel with:
- **Email**: admin@boldbrew.com
- **Password**: SecurePassword123!
- **URL**: http://localhost:3000/admin

## 📁 Project Structure

```
bold_brew/
├── app/
│   ├── controllers/
│   │   ├── admin/           # Admin panel controllers
│   │   ├── users/           # Custom Devise controllers
│   │   └── ...              # Main application controllers
│   ├── models/              # ActiveRecord models
│   ├── views/               # ERB templates
│   ├── javascript/          # Stimulus controllers
│   └── assets/              # Static assets
├── config/
│   ├── routes.rb            # Application routes
│   ├── database.yml         # Database configuration
│   └── initializers/        # App initializers
├── db/
│   ├── migrate/             # Database migrations
│   └── seeds.rb             # Sample data
└── ...
```

## 🔧 Configuration

### Stripe Setup
1. Create a Stripe account at [stripe.com](https://stripe.com)
2. Get your API keys from the dashboard
3. Add them to your `.env` file
4. For webhooks, set endpoint to: `https://yourdomain.com/stripe/webhooks`

### Cloudinary Setup
1. Create account at [cloudinary.com](https://cloudinary.com)
2. Get your cloud credentials from the console
3. Add them to your `.env` file

### Email Configuration (Production)
Configure SMTP settings in `config/environments/production.rb`:

```ruby
config.action_mailer.smtp_settings = {
  user_name: 'your_smtp_username',
  password: 'your_smtp_password',
  address: 'smtp.your-provider.com',
  port: 587,
  authentication: :plain
}
```

## 🚀 Deployment

### Render Deployment
The application is configured for Render deployment:

1. Connect your GitHub repository to Render
2. Set environment variables in Render dashboard
3. Deploy with the provided configuration

### Other Platforms
For other platforms, ensure:
- All environment variables are set
- Database is PostgreSQL
- Asset compilation is enabled
- SSL is configured

## 🧪 Testing

```bash
# Run the full test suite
bundle exec rspec

# Run specific test files
bundle exec rspec spec/models/user_spec.rb

# Run with coverage
COVERAGE=true bundle exec rspec
```

## 📚 Key Features Explained

### Smart Cart Management
- **Guest Users**: Carts stored in session, persist across browser sessions
- **Sign In**: Guest carts automatically transfer to user accounts
- **Sign Out**: User carts are cleared for privacy
- **Merge Logic**: If user has existing cart items, quantities are combined

### Order Workflow
1. **Pending**: Order created, awaiting payment
2. **Paid**: Payment confirmed via Stripe webhook
3. **Shipped**: Admin marks as shipped
4. **Canceled**: Can be canceled by user or admin

### Admin Panel
Access at `/admin` with admin privileges:
- Product management with image uploads
- Category organization
- Order processing and status updates
- User administration

## 🔐 Security Features

- CSRF protection enabled
- SQL injection prevention via ActiveRecord
- XSS protection with Rails sanitization
- Secure authentication with Devise
- Input validation and sanitization
- Secure cookie settings

## 🐛 Troubleshooting

### Common Issues

**Migration Errors**
```bash
# Check migration status
rails db:migrate:status

# Reset database (development only)
rails db:reset
```

**Asset Issues**
```bash
# Precompile assets
rails assets:precompile

# Clear asset cache
rails tmp:clear
```

**Cart Issues**
- Ensure session storage is working
- Check that Warden hooks in `config/initializers/devise.rb` are configured
- Verify cart transfer logic in ApplicationController

**Stripe Webhooks**
- Ensure webhook URL is correct
- Verify webhook secret in Rails credentials
- Check webhook logs in Stripe dashboard

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙋‍♂️ Support

For support and questions:
- Create an issue on GitHub
- Check the troubleshooting section above
- Review the Rails and Stripe documentation

## 🗺️ Roadmap

- [ ] Email notifications for order updates
- [ ] Product reviews and ratings
- [ ] Wishlist functionality
- [ ] Inventory management
- [ ] Multi-currency support
- [ ] Advanced search filters
- [ ] Product variants (size, color)
- [ ] Coupon and discount system

---

**Bold Brew** - Crafted with ❤️ and ☕
