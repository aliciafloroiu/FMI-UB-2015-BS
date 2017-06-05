import binaryTree.*;
import java.io.*;
import java.util.*;

class Parent implements Comparable<Parent> {
	public String nume;
	public int varsta;
	
	public Parent(String nume, int varsta) {
		this.nume = nume;
		this.varsta = varsta;
	}
	
	public int compareTo(Parent obj) {
		return nume.compareTo(obj.nume);
	}
}

class Child extends Parent {
	public Child(String nume, int varsta) {
		super(nume, varsta);
	}
	
	public int compareTo(Parent obj) {
		return varsta - obj.varsta;
	}
}

public class p4 {
	public static void main(String[] args) throws Exception {
		binaryTree<Integer, Integer> bt = new binaryTree<Integer, Integer>();
		
		File fin = new File("date.in");
		Scanner sc = null;
		
		try {
			sc = new Scanner(fin);
			
			while (sc.hasNextInt()) {
				int nr = sc.nextInt();
				bt.insert(nr, nr);
			}
			
		} catch (Exception ex) {
			throw ex;
		} finally {
			if (sc != null) {
				sc.close();
			}
		}
		
		System.out.println(bt);
		
		binaryTree<Parent, Integer> btp = new binaryTree<Parent, Integer>();
		btp.insert(new Parent("b", 40), 2);
		btp.insert(new Parent("a", 20), 4);
		btp.insert(new Parent("c", 30), 1);
		btp.insert(new Parent("d", 10), 3);
		System.out.println(btp);
		
		binaryTree<Parent, Integer> btc = new binaryTree<Parent, Integer>();
		btc.insert(new Child("b", 40), 2);
		btc.insert(new Child("a", 20), 4);
		btc.insert(new Child("c", 30), 1);
		btc.insert(new Child("d", 10), 3);
		System.out.println(btc);
	}
}