package com.jsp.util;

import redis.clients.jedis.Jedis;

public class RedisUtil {
    private static Jedis jedis;

    // Initialize the Redis connection
    static {
        // Use "redis" as the hostname, matching the service name in docker-compose.yml
        jedis = new Jedis("redis", 6379);
    }

    // Method to get the Jedis instance
    public static Jedis getJedis() {
        return jedis;
    }

    // Method to close the Redis connection
    public static void close() {
        if (jedis != null) {
            jedis.close();
        }
    }
}
