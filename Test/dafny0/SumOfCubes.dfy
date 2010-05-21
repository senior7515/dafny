class SumOfCubes {
  static function SumEmUp(n: int, m: int): int
    requires 0 <= n && n <= m;
    decreases m - n;
  {
    if m == n then 0 else n*n*n + SumEmUp(n+1, m)
  }

  static method Socu(n: int, m: int) returns (r: int)
    requires 0 <= n && n <= m;
    ensures r == SumEmUp(n, m);
  {
    call a := SocuFromZero(m);
    call b := SocuFromZero(n);
    r := a - b;
    call Lemma0(n, m);
  }

  static method SocuFromZero(k: int) returns (r: int)
    requires 0 <= k;
    ensures r == SumEmUp(0, k);
  {
    call g := Gauss(k);
    r := g * g;
    call Lemma1(k);
  }

  ghost static method Lemma0(n: int, m: int)
    requires 0 <= n && n <= m;
    ensures SumEmUp(n, m) == SumEmUp(0, m) - SumEmUp(0, n);
  {
    var k := n;
    while (k < m) 
      invariant n <= k && k <= m;
      invariant SumEmDown(0, n) + SumEmDown(n, k) == SumEmDown(0, k);
      decreases m - k;
    {
      k := k + 1;
    }
    call Lemma3(0, n);
    call Lemma3(n, k);
    call Lemma3(0, k);
  }

  static function GSum(k: int): int
    requires 0 <= k;
    decreases k;
  {
    if k == 0 then 0 else GSum(k-1) + k-1
  }

  static method Gauss(k: int) returns (r: int)
    requires 0 <= k;
    ensures r == GSum(k);
  {
    r := k * (k - 1) / 2;
    call Lemma2(k);
  }

  ghost static method Lemma1(k: int)
    requires 0 <= k;
    ensures SumEmUp(0, k) == GSum(k) * GSum(k);
  {
    var i := 0;
    while (i < k)
      invariant i <= k;
      invariant SumEmDown(0, i) == GSum(i) * GSum(i);
      decreases k - i;
    {
      call Lemma2(i);
      i := i + 1;
    }
    call Lemma3(0, k);
  }

  ghost static method Lemma2(k: int)
    requires 0 <= k;
    ensures 2 * GSum(k) == k * (k - 1);
  {
    var i := 0;
    while (i < k)
      invariant i <= k;
      invariant 2 * GSum(i) == i * (i - 1);
      decreases k - i;
    {
      i := i + 1;
    }
  }

  static function SumEmDown(n: int, m: int): int
    requires 0 <= n && n <= m;
    decreases m;
  {
    if m == n then 0 else SumEmDown(n, m-1) + (m-1)*(m-1)*(m-1)
  }

  ghost static method Lemma3(n: int, m: int)
    requires 0 <= n && n <= m;
    ensures SumEmUp(n, m) == SumEmDown(n, m);
  {
    var k := n;
    while (k < m)
      invariant n <= k && k <= m;
      invariant SumEmUp(n, m) == SumEmDown(n, k) + SumEmUp(k, m);
      decreases m - k;
    {
      k := k + 1;
    }
  }
}