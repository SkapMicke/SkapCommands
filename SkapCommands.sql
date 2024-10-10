CREATE TABLE IF NOT EXISTS banned_players (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id VARCHAR(50) NOT NULL,
    reason VARCHAR(255),
    ban_time INT NOT NULL,
    ban_expiration TIMESTAMP,
    banned_by VARCHAR(50),
    ban_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
