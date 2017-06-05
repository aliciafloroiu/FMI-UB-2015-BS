import java.io.*;
import java.net.*;
import java.util.*;

public class Client {
	private static class ChatClientData {
		private Socket socket;
		private Scanner input;
		private PrintWriter output;
		private String message;
		private Communication communication;
		
		public ChatClientData(Socket socket) throws Exception {
			this.socket = socket;
			this.input = new Scanner(this.socket.getInputStream());
			this.output = new PrintWriter(this.socket.getOutputStream());
			this.communication = Communication.getInstance();
		}
		
		public Socket getSocket() {
			return this.socket;
		}
		
		public Scanner getInput() {
			return this.input;
		}
		
		public PrintWriter getOutput() {
			return this.output;
		}
		
		public String getMessage() {
			return this.message;
		}
		
		public Communication getCommunication() {
			return this.communication;
		}
		
		public void setMessage(String message) {
			this.message = message;
		}
		
		public void sendMessage(PrintWriter output, String message) {
			this.communication.sendMessage(output, message);
		}
	}
	
	private static class ChatClient implements Runnable {
		private ChatClientData chatClientData;
		
		public ChatClient(Socket socket) throws Exception {
			chatClientData = new ChatClientData(socket);
		}
		
		public void run() {
			try {
				checkStream();
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
		}
		
		private void checkStream() throws Exception {
			while (true) {
				if (this.chatClientData.getInput().hasNextLine()) {
					this.chatClientData.setMessage(this.chatClientData.getInput().nextLine());
					
					System.out.println(this.chatClientData.getMessage());
				} else { // server has closed
					System.out.println("Connection closed.");
					System.exit(0);
				}
			}
		}
		
		public void sendToServer(String type, String content) throws Exception {
			this.chatClientData.setMessage(this.chatClientData.getCommunication().encodeJSON(type, content));
			this.chatClientData.sendMessage(this.chatClientData.getOutput(), this.chatClientData.getMessage());
		}
	}
	
	private static void addUser(Socket socket) throws Exception {
		Scanner input = new Scanner(socket.getInputStream());
		PrintWriter output = new PrintWriter(socket.getOutputStream());
		Communication communication = Communication.getInstance();
		
		while (true) {
			System.out.println("Username: ");
			String username = scanner.nextLine();
			output.println(username);
			output.flush();
			
			String message = input.nextLine();
			communication.decodeJSON(message);
			if (communication.Type.equals(Communication.CommunicationType.SUCCESS.name())) {
				System.out.println("Your are now connected.");
				
				break;
			} else {
				System.out.println("Invalid username, please try again.");
			}
		}
	}
	
	private static Scanner scanner = null;
	private static Socket socket;
	private static ChatClient chatClient;
	public static void main(String[] args) {
		try {
			scanner = new Scanner(System.in);
			
			final String HOST = "localhost";
			socket = new Socket(HOST, 8000);
			
			chatClient = new ChatClient(socket);
			
			addUser(socket);
			
			Thread thread = new Thread(chatClient);
			thread.start();
			
			System.out.println("Type /o to see the available options.");
			
			Communication communication = Communication.getInstance();
			while (true) {
				String message = scanner.nextLine();
				
				if (message.length() >= 2 && message.substring(0, 2).equals("/o")) {
					System.out.println("/w USERNAME - talk with a person");
					System.out.println("/a MESSAGE - send a broadcast message");
					System.out.println("/m - go back to main menu");
					System.out.println("/users - see all online users");
					System.out.println("/exit - exit the chat");
				} else {
					communication.translateCommunication(message);
					chatClient.sendToServer(communication.Type, communication.Content);
				}
			}
			
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
	}
}