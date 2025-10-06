INSERT INTO users (username, email, password) VALUES ('juanperez', 'juan@example.com', 'password123');
INSERT INTO users (username, email, password) VALUES ('mariagomez', 'maria@example.com', 'securepass');
INSERT INTO users (username, email, password) VALUES ('carloslopez', 'carlos@example.com', 'mypassword');
INSERT INTO users (username, email, password) VALUES ('anaruiz', 'ana@example.com', 'anapass');
INSERT INTO users (username, email, password) VALUES ('luissanchez', 'luis@example.com', 'luispass');
INSERT INTO users (username, email, password) VALUES ('andreamorales', 'andrea@example.com', 'andrea123');
INSERT INTO users (username, email, password) VALUES ('pedrohernandez', 'pedro@example.com', 'pedro456');
INSERT INTO users (username, email, password) VALUES ('sofialopez', 'sofia@example.com', 'sofia789');
INSERT INTO users (username, email, password) VALUES ('martingarcia', 'martin@example.com', 'martin111');
INSERT INTO users (username, email, password) VALUES ('luciafernandez', 'lucia@example.com', 'lucia222');
INSERT INTO users (username, email, password) VALUES ('ricardomartinez', 'ricardo@example.com', 'ricardo333');
INSERT INTO users (username, email, password) VALUES ('elenaortega', 'elena@example.com', 'elena444');
INSERT INTO users (username, email, password) VALUES ('julioramirez', 'julio@example.com', 'julio555');
INSERT INTO users (username, email, password) VALUES ('pablocastro', 'pablo@example.com', 'pablo666');
INSERT INTO users (username, email, password) VALUES ('lauradiaz', 'laura@example.com', 'laura777');
INSERT INTO users (username, email, password) VALUES ('danielarojas', 'daniela@example.com', 'daniela888');
INSERT INTO users (username, email, password) VALUES ('carlossosa', 'carlos2example.com', 'carlos999');
INSERT INTO users (username, email, password) VALUES ('aliciacruz', 'alicia@example.com', 'alicia000');
INSERT INTO users (username, email, password) VALUES ('jorgegomez', 'jorge@example.com', 'jorge1234');
INSERT INTO users (username, email, password) VALUES ('susanarodriguez', 'susana@example.com', 'susana5678');

COMMIT;


INSERT INTO tweets (user_id, content) VALUES (1, 'Explorando nuevas tecnologías cada día.');
INSERT INTO tweets (user_id, content) VALUES (2, 'La clave del éxito es la perseverancia.');
INSERT INTO tweets (user_id, content) VALUES (3, '¿Alguien ha probado el nuevo framework?');
INSERT INTO tweets (user_id, content) VALUES (4, 'La música me ayuda a concentrarme.');
INSERT INTO tweets (user_id, content) VALUES (5, '¡Hoy es un buen día para programar!');
INSERT INTO tweets (user_id, content) VALUES (6, 'Me encanta trabajar en proyectos creativos.');
INSERT INTO tweets (user_id, content) VALUES (7, 'El café es mi mejor aliado en la programación.');
INSERT INTO tweets (user_id, content) VALUES (8, 'Estoy aprendiendo nuevas habilidades cada día.');
INSERT INTO tweets (user_id, content) VALUES (9, 'El diseño es tan importante como el código.');
INSERT INTO tweets (user_id, content) VALUES (10, 'La comunidad de desarrolladores es increíble.');
INSERT INTO tweets (user_id, content) VALUES (11, 'Siempre hay algo nuevo que aprender.');
INSERT INTO tweets (user_id, content) VALUES (12, 'El trabajo en equipo hace que el sueño funcione.');
INSERT INTO tweets (user_id, content) VALUES (13, 'La creatividad es la inteligencia divirtiéndose.');
INSERT INTO tweets (user_id, content) VALUES (14, 'El código limpio es un arte.');
INSERT INTO tweets (user_id, content) VALUES (15, 'La tecnología está cambiando el mundo.');
INSERT INTO tweets (user_id, content) VALUES (16, 'La programación es resolver problemas.');
INSERT INTO tweets (user_id, content) VALUES (17, 'El aprendizaje nunca se detiene.');
INSERT INTO tweets (user_id, content) VALUES (18, 'La innovación es la madre de la invención.');
INSERT INTO tweets (user_id, content) VALUES (19, 'El diseño es crucial en cualquier proyecto.');
INSERT INTO tweets (user_id, content) VALUES (20, 'Resolver problemas es gratificante.');

COMMIT;

INSERT INTO followers (follower_id, following_id) VALUES (1, 2);
INSERT INTO followers (follower_id, following_id) VALUES (1, 3);
INSERT INTO followers (follower_id, following_id) VALUES (2, 1);
INSERT INTO followers (follower_id, following_id) VALUES (2, 4);
INSERT INTO followers (follower_id, following_id) VALUES (3, 5);
INSERT INTO followers (follower_id, following_id) VALUES (4, 6);
INSERT INTO followers (follower_id, following_id) VALUES (5, 7);
INSERT INTO followers (follower_id, following_id) VALUES (6, 8);
INSERT INTO followers (follower_id, following_id) VALUES (7, 9);
INSERT INTO followers (follower_id, following_id) VALUES (8, 10);
INSERT INTO followers (follower_id, following_id) VALUES (9, 11);
INSERT INTO followers (follower_id, following_id) VALUES (10, 12);
INSERT INTO followers (follower_id, following_id) VALUES (11, 13);
INSERT INTO followers (follower_id, following_id) VALUES (12, 14);
INSERT INTO followers (follower_id, following_id) VALUES (13, 15);
INSERT INTO followers (follower_id, following_id) VALUES (14, 16);
INSERT INTO followers (follower_id, following_id) VALUES (15, 17);
INSERT INTO followers (follower_id, following_id) VALUES (16, 18);
INSERT INTO followers (follower_id, following_id) VALUES (17, 19);
INSERT INTO followers (follower_id, following_id) VALUES (18, 20);

COMMIT;

INSERT INTO likes (user_id, tweet_id) VALUES (1, 2);
INSERT INTO likes (user_id, tweet_id) VALUES (2, 3);
INSERT INTO likes (user_id, tweet_id) VALUES (3, 4);
INSERT INTO likes (user_id, tweet_id) VALUES (4, 5);
INSERT INTO likes (user_id, tweet_id) VALUES (5, 6);
INSERT INTO likes (user_id, tweet_id) VALUES (6, 7);
INSERT INTO likes (user_id, tweet_id) VALUES (7, 8);
INSERT INTO likes (user_id, tweet_id) VALUES (8, 9);
INSERT INTO likes (user_id, tweet_id) VALUES (9, 10);
INSERT INTO likes (user_id, tweet_id) VALUES (10, 11);
INSERT INTO likes (user_id, tweet_id) VALUES (11, 12);
INSERT INTO likes (user_id, tweet_id) VALUES (12, 13);
INSERT INTO likes (user_id, tweet_id) VALUES (13, 14);
INSERT INTO likes (user_id, tweet_id) VALUES (14, 15);
INSERT INTO likes (user_id, tweet_id) VALUES (15, 16);
INSERT INTO likes (user_id, tweet_id) VALUES (16, 17);
INSERT INTO likes (user_id, tweet_id) VALUES (17, 18);
INSERT INTO likes (user_id, tweet_id) VALUES (18, 19);
INSERT INTO likes (user_id, tweet_id) VALUES (19, 20);
INSERT INTO likes (user_id, tweet_id) VALUES (20, 1);

COMMIT;

-- Inserciones para la tabla comments
INSERT INTO comments (tweet_id, user_id, content) VALUES (1, 2, '¡Genial! Bienvenido a Twitter.');
INSERT INTO comments (tweet_id, user_id, content) VALUES (2, 3, '¡Totalmente de acuerdo!');
INSERT INTO comments (tweet_id, user_id, content) VALUES (3, 4, '¡Así es!');
INSERT INTO comments (tweet_id, user_id, content) VALUES (4, 5, '¡Yo también!');
INSERT INTO comments (tweet_id, user_id, content) VALUES (5, 1, '¡Exactamente!');
INSERT INTO comments (tweet_id, user_id, content) VALUES (6, 3, '¡Eso suena interesante!');
INSERT INTO comments (tweet_id, user_id, content) VALUES (7, 4, '¡Totalmente de acuerdo!');
INSERT INTO comments (tweet_id, user_id, content) VALUES (8, 5, 'Me gusta Python.');
INSERT INTO comments (tweet_id, user_id, content) VALUES (9, 1, '¡El café es vida!');
INSERT INTO comments (tweet_id, user_id, content) VALUES (10, 2, '¡Yo también!');
INSERT INTO comments (tweet_id, user_id, content) VALUES (11, 2, '¡Eso es genial!');
INSERT INTO comments (tweet_id, user_id, content) VALUES (12, 3, '¡Muy cierto!');
INSERT INTO comments (tweet_id, user_id, content) VALUES (13, 4, 'Todavía no, pero quiero probarlo.');
INSERT INTO comments (tweet_id, user_id, content) VALUES (14, 5, 'La música es vida.');
INSERT INTO comments (tweet_id, user_id, content) VALUES (15, 1, '¡Totalmente de acuerdo!');
INSERT INTO comments (tweet_id, user_id, content) VALUES (16, 3, 'El diseño es crucial.');
INSERT INTO comments (tweet_id, user_id, content) VALUES (17, 4, 'La comunidad es lo mejor.');
INSERT INTO comments (tweet_id, user_id, content) VALUES (18, 5, 'Siempre hay algo nuevo.');
INSERT INTO comments (tweet_id, user_id, content) VALUES (19, 1, 'El trabajo en equipo es clave.');
INSERT INTO comments (tweet_id, user_id, content) VALUES (20, 2, 'La creatividad es esencial.');

COMMIT;