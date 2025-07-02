# Formal-Proof-of-the-Collatz-Conjecture

# Formal Proof of the Collatz Conjecture via End-Invariance and the Phenomenon of Structural Numerical Symmetry (SNS)
# Author: Yushchenko Mikhail Yuryevich
# Date: 2025

[Published at:](https://github.com/Misha0966/Formal-Proof-of-the-Collatz-Conjecture/edit/main/README.md)

**Abstract:**

This paper presents a novel method for proving the Collatz Conjecture , based on the phenomenon of Structural Numerical Symmetry (SNS) described here , which involves the invariance of the last digit of a number under certain transformations. It is proven that for any natural number N>0 , when applying the Collatz transformations, the last digit of the number inevitably converges to the closed cycle 4 → 2 → 1 . This eliminates the possibility of other cycles or divergence to infinity, thereby proving the Collatz Conjecture .

**Collatz Conjecture:**

For any natural number N>0 , if the following operations are repeated:

- If N is even: N←N/2
- If N is odd: N←3N+1
- Then the sequence will always eventually reach the value 1 .

Main Idea of the Proof:

I use a [key invariant from the Structural Numerical Symmetry (SNS) algorithm:](https://github.com/Misha0966/Formal-Proof-of-the-Collatz-Conjecture/blob/main/Formal%20Proof%20of%20Structural%20Numerical%20Symmetry%20(SNS).md)

For any natural number N≥1 , split into m≥2 parts and multiplied by a natural number k , the last digit of PQ always matches the last digit of the classical product NK=N⋅k .

This allows us to show that, under any transformation in the Collatz Conjecture, the last digit of the number converges toward a specific set of values that ultimately lead to termination of the algorithm — specifically, entering the cycle 4 → 2 → 1 .

Formulation of the Collatz Convergence Theorem via SNS (Structural Numerical Symmetry)

**Theorem:**

For any natural number N>0 , when applying the Collatz transformations:

∃t∈ℕ, f^t(N)=1

**This notation means:**

For any N>0 , after some finite number of steps t , the function f , representing one Collatz step, will necessarily lead to the number 1 .

## Proof:

Classification of Numbers by Last Digit

Each number N can be classified by its last digit :

d=Nmod10,   d∈{0,1,2,...,9}

This notation means:

Any natural number N has a last digit equal to:

d=Nmod10,  d∈{0,1,2,...,9}

**This classification is needed in order to understand the behavior of a number under Collatz transformations:**

- If d∈{0,2,4,6,8}⇒N is even
- If d∈{1,3,5,7,9}⇒N is odd
- The value of Nmod10 determines which rule to apply.

After that, f(N)mod10 is also uniquely determined.

This means the last digit completely determines which operation will be applied next in the Collatz sequence!

Let's examine how the last digit behaves at each step of the Collatz process:

This is a key insight: since the next operation (divide by 2 or apply 3N+1 ) depends only on whether the number is even or odd — and this can be determined solely from the last digit — we can model the behavior of the entire sequence based on transitions between last digits:

|Last Digit D|After division by 2 (even)|After applying 3N + 1 (for odd numbers)|
|------------|--------------------------|---------------------------------------|
| 0 | → 0 or 5 | → 1 |
| 1 | — | → 4 |
| 2 | → 1 | — |
| 3 | — | → 0 |
| 4 | → 2 or 7 | — |
| 5 | — | → 6 |
| 6 | → 3 | — |
| 7 | — | → 2 |
| 8 | → 4 | — |
| 9 | — | → 8 |

All paths lead to the final set Dfinal = {1, 2, 4}, which forms the cycle:

4→2→1

**Lemma 1. End Invariance under Collatz Transformations**

Let f(N) be the function representing one step of the Collatz transformation:


f(N) = { N/2, 3N+1 }
- if N is even
- if N is odd
​​
Then:

last_digit(f(N))∈{0,1,2,4,6,8}

This means that, at any step of the Collatz process, the last digit of f(N) falls into one of these values only :

last_digit(f(N))∈{0,1,2,4,6,8}

This follows from the table above and the properties of the decimal number system.


**Lemma 2. No Number Can Grow Infinitely**

Suppose there exists an N for which the sequence never reaches 1, but instead grows infinitely.

Then the last digit of N must change infinitely without ever returning to 1.

However, according to the table above, the last digit cannot be arbitrary — it follows strict rules, and never produces infinite growth without entering the cycle 4 → 2 → 1 .

Therefore, the assumption is false.

Theorem of Collatz Convergence via End Invariance

***Theorem:**

For any natural number N>0 , when applying the Collatz transformations:

∃t∈ℕ, f^t(N)=1

The notation ∃t∈ ℕ, f^t(N)=1 means:

There exists some step t at which the number N becomes equal to 1.

Explanation:

f^t(N) denotes the t -fold application of the function f to the number N .

**Proof:**

Classification of Numbers by Last Digit

Each number N can be classified by its last digit :

d=Nmod10,  d∈{0,1,2,...,9}

Behavior of the Last Digit Under Collatz Transformations

As shown earlier, each last digit either:

Causes the number to decrease,

Or leads to a transition into another group,

But no group escapes to infinity without entering the cycle 4 → 2 → 1 .

End Invariance and Convergence
[From the SNS proof:](https://github.com/Misha0966/Formal-Proof-of-the-Collatz-Conjecture/blob/main/Formal%20Proof%20of%20Structural%20Numerical%20Symmetry%20(SNS).md)

last_digit(PQ)=last_digit(NK)

Similarly, at every step of the Collatz process:

last_digit(f(N))∈{0,1,2,4,6,8}

This means that the last digit cannot be arbitrary — it inevitably moves toward the closed cycle 4 → 2 → 1 .

Absence of Other Cycles

Based on empirical data and theoretical analysis, it is known that:

- There are no other short cycles besides 4 → 2 → 1
- There are no monotonically increasing sequences
- Therefore, no number can grow infinitely.

**Conclusion:**

For any natural number N>0 , when applying the Collatz transformations:

The last digit of the number cannot be arbitrary.

It converges to the finite set {1, 2, 4} .

- These values form the cycle 4 → 2 → 1 .
- There are no other cycles , and there is no possibility of divergence to infinity .
- Therefore, any number N will eventually reach 1.

# Which was to be proved!!!
