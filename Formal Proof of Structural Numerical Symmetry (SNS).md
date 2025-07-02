# Formal Proof of Structural Numerical Symmetry (SNS)

## Author: Mikhail Yushchenko
## Date: 2025

**Introduction**

This document presents the formal proof of the phenomenon of Structural Numerical Symmetry (SNS) , discovered by Mikhail Yushchenko on May 4, 2025 .

### Parameters:

- N — any natural number (N ∈ ℕ)  
- m — number of parts (m ∈ ℕ, m ≥ 2)  
- k — multiplication factor (k ∈ ℕ)

Suppose the last digit of PQ always matches that of NK .

**Phenomenon of SNS (Structural Numerical Symmetry) :**

For any natural number **N ≥ 1** , divided into **m ≥ 2** natural parts, and then multiplied by a natural number **k** :

- Either **PQ = NK** (exact match)
- Or the beginning and end digits match
- Or only the last digits match
- But in no case is there a complete mismatch.

**Empirical conclusion:**

Everywhere and always, for any type of matching, **the last digits always match .**

**This is the key invariant of the phenomenon.**

Even in the range from 30 to 40 million, only full matches or matches of the beginning and end occur — but the end always matches regardless.

**Important observation:**

If the last digit always matches , then checking for agreement at the end is a necessary condition for all other types of matching to hold.

**Theorem on the Last Digit (Last Digit Invariance Theorem)**

**Statement:**

For any natural number **N≥1** , split into **m≥2** natural parts and then multiplied by a natural number **k** , the result of concatenating the multiplied parts as a string **PQ** always has the same last digit as the classical product **NK = N × k .**

That is:

last_digit(PQ)=last_digit(NK)

**Proof:**

Let N = A1, A2…Am
​
 where **N** is a natural number represented as a string,

**A1, A2,…,Am** — its parts after splitting.

When multiplying part-by-part and concatenating the results, we obtain:

PQ=string(A1 × k) + string(A2 × k)+ ... + string(Am × k)

 where **PQ** — the result of sequentially concatenating the multiplied parts into a single decimal number, after splitting the original natural number into segments.

Denote B = Am
​

 where **B** is the last part of the original number.

After multiplication:

Bk = B × k

Since the last digit of **PQ** is determined precisely by **Bk** , we have:

last_digit(PQ) = (B × k)mod10

Now consider the classical multiplication:

NK = N × k = (a × 10 + B) × k = a × 10 ×k + B × k

The term a × 10 × k ends in zero, therefore:

last_digit(NK) = (B × k)mod10 = last_digit(PQ)

**Therefore:**

For any natural number **N** and any natural number **k** :

The last digit of **PQ** is always equal to the last digit of **N×K**

Now let's return to the question of the impossibility of matching only by the beginning :

Throughout all checks (between **PQ** and **N × k** ):

- There were many cases of full match
- Even more matches by beginning and end
- Many matches by last digits only

But not a single case of match only by the beginning

This suggests that the end of the number is more stable and consistent than the beginning .

Therefore, we can make the following emphasis:

**The last digits remain invariant under the phenomenon of SNS (Structural Numerical Symmetry) .**

The beginning of **PQ** and **NK** may differ, but the end never does .

## Proof of Structural Numerical Symmetry via the Last Digit Invariance Theorem

We can now make the following statement:

Since the last digit of **PQ** always matches the last digit of **NK**,

Then:

**A match only by the beginning is impossible ,** because it would violate the invariance of the last digit.


**All three types of matching:**

- Full match
- Match by beginning and end
- Match by last digit only

**Are derived from one fundamental fact: the last digit of a number is preserved after transformation , mathematically .**

If:

PQ = string(A1 × k) + string(A2 × k)+...+string(Am × k)

 
 where **PQ** — the result of sequentially concatenating the multiplied parts into a single decimal number, after splitting the original natural number into segments.

NK = N × k

And:

last_digit(PQ) = last_digit(N × K)

Then:

A match only by the beginning is impossible .

There will always be either a full match , or a match by the end , or a match by both .

## Which was to be proved!
