import java.util.Scanner
import scala.math.pow
// import scala.math.modPow

object Main {
  def main(args: Array[String]): Unit = {
    val sc = new Scanner(System.in)
    val n = sc.nextInt
    println(n)
  }
}

object Utils {
  /** 立ってるビットをカウント
   */
  def bitcount(n: Int): Int = {
    var x = n
    x = (x & 0x55555555) + (x >> 1 & 0x55555555)
    x = (x & 0x33333333) + (x >> 2 & 0x33333333)
    x = (x & 0x0F0F0F0F) + (x >> 4 & 0x0F0F0F0F)
    x = (x & 0x00FF00FF) + (x >> 8 & 0x00FF00FF)
    x = (x & 0x0000FFFF) + (x >> 16 & 0x0000FFFF)
    x
  }

  /** 約数列挙
   */
  def divisors(n: Long): Set[Long] = {
    // def foo()
    var r: Set[Long] = Set(1L, n)
    var i: Long = 2
    while (pow(i.toDouble, 2) <= n) {
      if (n % i == 0) {
        r += i
        r += n / i
      }
      i += 1
    }
    r
  }

  /** 拡張ユークリッドの互除法
   * ax + by = gcd(a, b)
   * d = gcd(a, b) として d, x, y を求める
   * d = bx' + (a%b)y' ... a%b = a - (a/b)b より
   * ay' + b(x' - (a/b)y')
   */
  def extgcd(a: Long, b: Long): (Long, Long, Long) = {
    b match {
      case 0 => (a, 1L, 0L)
      case _ =>
        val (d, x, y) = extgcd(b, a % b)
        (d, y, x - a / b * y)
    }
  }

  /** 素因数分解
   */
  def factorize(n: Long): List[Long] = {
    def foo(x: Long, i: Long, res: List[Long]): List[Long] = {
      x < i * i match {
        case false if x % i == 0 => foo(x / i, i, i :: res)
        case false => foo(x, i + 1, res)
        case true => x :: res
      }
    }
    foo(n, 2L, Nil)
  }

  /** エラトステネスの篩
   */
  def sieveEratosthenes(n: Int): List[Int] = {
    def foo(check: List[Int], res: List[Int], end: Int): List[Int] = {
      val (x, xs) = (check.head, check.tail)
      if (x * x <= end) foo(xs.filter(_ % x != 0), x :: res, end)
      else res.reverse ++ check
    }
    foo((2 to n).toList, Nil, n)
  }
}
