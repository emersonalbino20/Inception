name = inception

all:
	@docker compose -f srcs/docker-compose.yml up -d --build

up:
	@docker compose -f srcs/docker-compose.yml up -d

down:
	@docker compose -f srcs/docker-compose.yml down

clean:
	@docker compose -f srcs/docker-compose.yml down -v --rmi all

fclean: clean
	@sudo rm -rf /home/ealbino/data/wordpress/*
	@sudo rm -rf /home/ealbino/data/mariadb/*
	@docker system prune -a --force

re: fclean all

.PHONY: all up down clean fclean re
