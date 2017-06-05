import java.io.*;
import java.util.*;

public class p3 {
	private static int n;
	private static class pair implements Comparable<pair> {
		int p, t, nr;
		
		pair(int p, int t, int nr) {
			this.p = p;
			this.t = t;
			this.nr = nr;
		}
		
		public int compareTo(pair obj) {
			return obj.p - p;
		}
	}
	
	private static ArrayList<pair> v = new ArrayList<pair>();
	private static ArrayList<Integer> T = new ArrayList<Integer>();
	
	private static void read() throws Exception {
		File fin = new File("date.in");
		Scanner sc = null;
		
		try {
			sc = new Scanner(fin);
			
			n = sc.nextInt();
			for (int i = 1; i <= n; ++i) {
				int p = sc.nextInt();
				int t = sc.nextInt();
				
				v.add(new pair(p, t, i));
			}
		} catch (Exception ex) {
			throw ex;
		} finally {
			if (sc != null) {
				sc.close();
			}
		}
	}
	
	private static void update(int x, int y) {
		T.set(y, x);
	}
	
	private static int query(int x) {
		if (T.get(x) == x)
			return x;
		
		T.set(x, query(T.get(x)));
		return T.get(x);
	}
	
	private static void solve() throws Exception {
		Writer wr = new FileWriter("date.out");
		
		Collections.sort(v);
		ArrayList<Integer> w = new ArrayList<Integer>();
		int s = 0;
		
		for (int i = 0; i <= n; ++i) {
			T.add(i);
			w.add(0);
		}
		
		for (pair el : v) {
			int q = query(el.t);
			if (q != 0) {
				s += el.p;
				w.set(q, el.nr);
				update(el.t - 1, el.t);
			}
		}
		
		wr.write(s + "\n");
		for (int el : w) {
			if (el != 0) {
				wr.write(el + " ");
			}
		}
		wr.write("\n");
		
		wr.close();
	}
	
	public static void main(String[] args) throws Exception {
		read();
		solve();
	}
}