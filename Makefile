install:
	composer install
	cp .env.example .env
	php artisan key:gen --ansi
	php artisan migrate
	npm ci
	npm run build

start:
	php artisan serve --host 0.0.0.0
