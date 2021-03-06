DROP TABLE IF EXISTS user;
CREATE TABLE user (
  player_id INTEGER PRIMARY KEY NOT NULL
);
INSERT INTO user VALUES (2);

--------------------------------------------------------------------------------

DROP TABLE IF EXISTS game;
CREATE TABLE game (
  game_id INTEGER PRIMARY KEY NOT NULL
);

--------------------------------------------------------------------------------

DROP TABLE IF EXISTS event;
CREATE TABLE event (
  event_id INTEGER PRIMARY KEY NOT NULL,
  event_timestamp DATETIME NOT NULL,
  event_predicate VARCHAR(63) NOT NULL,
  event_subject INTEGER NULL,
  event_object INTEGER NULL
);

--------------------------------------------------------------------------------

DROP TABLE IF EXISTS message;
CREATE TABLE message (
  message_id INTEGER PRIMARY KEY NOT NULL,
  message_timestamp DATETIME NOT NULL,
  message_seen BOOLEAN NOT NULL,
  message_sender INTEGER NULL,
  message_recipient INTEGER NULL,
  message_language VARCHAR(5) NULL,
  message_text TEXT NULL,
  message_audio BLOB NULL
);

--------------------------------------------------------------------------------

DROP TABLE IF EXISTS player;
CREATE TABLE player (
  player_id INTEGER PRIMARY KEY NOT NULL,
  player_nick TEXT NOT NULL,
  player_rank TEXT NULL,
  player_headset BOOLEAN NULL,
  player_heartrate INTEGER NULL,
  player_distance REAL NULL,
  player_position_x REAL NULL,
  player_position_y REAL NULL,
  player_position_z REAL NULL,
  player_avatar BLOB NULL
);

--------------------------------------------------------------------------------

DROP TABLE IF EXISTS target;
CREATE TABLE target (
  target_id INTEGER PRIMARY KEY NOT NULL
);
