-- Create the first table
CREATE TABLE session (
    sessionId TEXT PRIMARY KEY,
    conversationId TEXT UNIQUE,
    title TEXT,
    timestamp DATETIME
);

-- Create the second table
CREATE TABLE conversation (
    id INTEGER PRIMARY KEY,
    conversationId TEXT,
    role VARCHAR(50),
    message TEXT,
    timestamp DATETIME,
    FOREIGN KEY (conversationId) REFERENCES session(conversationId)
);
