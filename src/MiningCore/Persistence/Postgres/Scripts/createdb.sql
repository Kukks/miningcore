﻿set role miningcore;

CREATE TABLE shares
(
	id BIGSERIAL NOT NULL PRIMARY KEY,
	poolid TEXT NOT NULL,
	blockheight BIGINT NOT NULL,
	difficulty DOUBLE PRECISION NOT NULL,
	networkdifficulty DOUBLE PRECISION NOT NULL,
	payoutinfo TEXT NULL,
	miner TEXT NOT NULL,
	worker TEXT NULL,
	useragent TEXT NULL,
	ipaddress TEXT NOT NULL,
	created TIMESTAMP NOT NULL
);

CREATE INDEX IDX_SHARES_POOL_BLOCK on shares(poolid, blockheight);
CREATE INDEX IDX_SHARES_POOL_MINER on shares(poolid, miner);
CREATE INDEX IDX_SHARES_POOL_CREATED ON shares(poolid, created);
CREATE INDEX IDX_SHARES_POOL_MINER_DIFF on shares(poolid, miner, difficulty);

CREATE TABLE blocks
(
	id BIGSERIAL NOT NULL PRIMARY KEY,
	poolid TEXT NOT NULL,
	blockheight BIGINT NOT NULL,
	networkdifficulty DOUBLE PRECISION NOT NULL,
	status TEXT NOT NULL,
    type TEXT NULL,
    confirmationprogress FLOAT NOT NULL DEFAULT 0,
	effort FLOAT NULL,
	transactionconfirmationdata TEXT NOT NULL,
	reward decimal(28,12) NULL,
	created TIMESTAMP NOT NULL
);

CREATE INDEX IDX_BLOCKS_POOL_BLOCK_STATUS on blocks(poolid, blockheight, status);

CREATE TABLE balances
(
	poolid TEXT NOT NULL,
	coin TEXT NOT NULL,
	address TEXT NOT NULL,
	amount decimal(28,12) NOT NULL DEFAULT 0,
	created TIMESTAMP NOT NULL,
	updated TIMESTAMP NOT NULL,

	primary key(poolid, address, coin)
);

CREATE TABLE payments
(
	id BIGSERIAL NOT NULL PRIMARY KEY,
	poolid TEXT NOT NULL,
	coin TEXT NOT NULL,
	address TEXT NOT NULL,
	amount decimal(28,12) NOT NULL,
	transactionconfirmationdata TEXT NOT NULL,
	created TIMESTAMP NOT NULL
);

CREATE INDEX IDX_PAYMENTS_POOL_COIN_WALLET on payments(poolid, coin, address);

CREATE TABLE poolstats
(
	id BIGSERIAL NOT NULL PRIMARY KEY,
	poolid TEXT NOT NULL,
	connectedminers INT NOT NULL DEFAULT 0,
	poolhashrate DOUBLE PRECISION NOT NULL DEFAULT 0,
	created TIMESTAMP NOT NULL
);

CREATE INDEX IDX_POOLSTATS_POOL_CREATED on poolstats(poolid, created);
CREATE INDEX IDX_POOLSTATS_POOL_CREATED_HOUR on poolstats(poolid, date_trunc('hour',created));

CREATE TABLE minerstats
(
	id BIGSERIAL NOT NULL PRIMARY KEY,
	poolid TEXT NOT NULL,
	miner TEXT NOT NULL,
	worker TEXT NULL,
	hashrate DOUBLE PRECISION NOT NULL DEFAULT 0,
	sharespersecond DOUBLE PRECISION NOT NULL DEFAULT 0,
	created TIMESTAMP NOT NULL
);

CREATE INDEX IDX_MINERSTATS_POOL_MINER_CREATED on minerstats(poolid, miner, created);
CREATE INDEX IDX_MINERSTATS_POOL_MINER_CREATED_HOUR on minerstats(poolid, miner, worker, date_trunc('hour',created));
