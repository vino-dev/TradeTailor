package com.TradeTailor.TradeTailor.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.TradeTailor.TradeTailor.service.ChatbotService;

import jakarta.servlet.http.HttpSession;
@RestController
public class ChatbotController {
	
	@Autowired
	private ChatbotService chat;
	@PostMapping("/chatbot/message")
	@ResponseBody
	public Map<String, String> getChatbotReply(@RequestBody Map<String, String> requestBody) {
	    String message = requestBody.get("message").toLowerCase();

	    String reply;

	    if (message.contains("hello")) {
	        reply = "Hello, how are you today?";
	    } else if (message.contains("stock")) {
	        String symbol = extractSymbolFromMessage(message);
	        if(symbol == null) {
	            reply = "Please specify a stock symbol, for example: 'stock AAPL'";
	        } else {
	            reply = chat.fetchLiveStock(symbol.toUpperCase());
	        }
	    } else {
	        reply = "I can help you with live stock details. Try asking: 'Show stock AAPL'.";
	    }

	    Map<String, String> response = new HashMap<>();
	    response.put("reply", reply);
	    return response;
	}

	private String extractSymbolFromMessage(String message) {
	    String[] words = message.split(" ");
	    for (int i = 0; i < words.length - 1; i++) {
	        if (words[i].equals("stock")) {
	            String symbolCandidate = words[i+1];
	            if(symbolCandidate.matches("[a-zA-Z]{1,5}")) {
	                return symbolCandidate.toUpperCase();
	            }
	        }
	    }
	    return null;
	}
	 @PostMapping
	    public Reply chat(@RequestBody Message message) {
	        String userInput = message.getMessage();

	        if (userInput == null || userInput.trim().isEmpty()) {
	            return new Reply("Please say something!");
	        }

	        // Simple echo reply
	        String reply = "You said: " + userInput;
	        return new Reply(reply);
	    }
	}

	// Request body class
	class Message {
	    private String message;

	    public Message() {}

	    public String getMessage() {
	        return message;
	    }

	    public void setMessage(String message) {
	        this.message = message;
	    }
	}

	// Response body class
	class Reply {
	    private String reply;

	    public Reply(String reply) {
	        this.reply = reply;
	    }

	    public String getReply() {
	        return reply;
	    }

	    public void setReply(String reply) {
	        this.reply = reply;
	    }
	

	
}
