using Printf
using CSV
using DataFrames
using Base.Threads
using ProgressMeter

# USER CONFIGURATION
const N_START = big"999"^big"999" # Can be replaced with any starting number
const M_SCS = 2 # Number of parts to split the number into
const K_SCS = 3 # Multiplier applied to each part
const MAX_ITERATIONS = typemax(Int) # Infinite loop until reaching 1

# FUNCTIONS:

# Splits number N into m parts as evenly as possible
function split_number_str(N::Integer, m::Integer)
s = string(N)

if length(s) < m
s = lpad(s, m, '0')
end

len = length(s)
base_len = div(len, m)
remainder = len % m
parts = String[]
idx = 1

for i in 1:m
current_len = base_len + (i <= remainder ? 1 : 0)
push!(parts, s[idx:idx+current_len-1])
idx += current_len
end

return parts
end

# Multiplies a string part preserving its original length
function multiply_preserve_length(part::String, k::Integer)
num = parse(BigInt, part) * k
result = string(num)
return lpad(result, max(length(part), length(result)), '0')
end

# Removes leading zeros from a string
function remove_leading_zeros(s::String)
if all(c -> c == '0', s)
return "0"
else
idx = findfirst(c -> c != '0', s)
return s[idx:end]
end
end

# Compares PQ and NK by beginning and end
function compare_pq_nk(pq::String, nk::String)
pq_clean = remove_leading_zeros(pq)
nk_clean = remove_leading_zeros(nk)

if pq_clean == nk_clean
return "✅ Full match"
end

min_len = min(length(pq_clean), length(nk_clean))
prefix_match = suffix_match = 0

for i in 1:min_len
pq_clean[i] == nk_clean[i] ? prefix_match += 1 : break
end

for i in 1:min_len
pq_clean[end - i + 1] == nk_clean[end - i + 1] ? suffix_match += 1 : break
end

if prefix_match > 0 && suffix_match > 0
return "🔄 Start and end match"
elseif prefix_match > 0
return "🔄 Only start matches"
elseif suffix_match > 0
return "🔄 Only end matches"
else
return "❌ No match"
end
end

# Collatz step function
function collatz_step(N::BigInt)
return iseven(N) ? N ÷ 2 : 3 * N + 1
end

# Checks SNS condition for current N
function check_scs_for_collatz_step(N::BigInt, m::Integer, k::Integer)
N_str = string(N)
nk_str = string(N * k)

parts_str = split_number_str(N, m)
multiplied_parts_str = [multiply_preserve_length(p, k) for p in parts_str]
pq_str = join(multiplied_parts_str)

pq_clean = remove_leading_zeros(pq_str)
nk_clean = remove_leading_zeros(nk_str)

result = compare_pq_nk(pq_clean, nk_clean)

return (
step = 0,
N = N,
parts = string(parts_str),
multiplied_parts = string(multiplied_parts_str),
PQ = pq_clean,
NK = nk_clean,
result = result
)
end

# Main loop: Collatz sequence with SNS analysis
function run_collatz_with_scs_analysis(N::BigInt, m::Integer, k::Integer, max_steps::Integer)
results_df = DataFrame(
step = Int[],
N = BigInt[],
parts = String[],
multiplied_parts = String[],
PQ = String[],
NK = String[],
result = String[]
)

full_matches = Atomic{Int}(0)
partial_both = Atomic{Int}(0)
partial_start = Atomic{Int}(0)
partial_end = Atomic{Int}(0)
no_matches = Atomic{Int}(0)

current_N = N
step_count = 0

@showprogress "🔁 Analyzing Collatz with SNS..." for _ in 1:max_steps
step_count += 1

res = check_scs_for_collatz_step(current_N, m, k)

Threads.atomic_add!(full_matches, res.result == "✅ Full match" ? 1 : 0)
Threads.atomic_add!(partial_both, res.result == "🔄 Start and end match" ? 1 : 0)
Threads.atomic_add!(partial_start, res.result == "🔄 Only start matches" ? 1 : 0)
Threads.atomic_add!(partial_end, res.result == "🔄 Only end matches" ? 1 : 0)
Threads.atomic_add!(no_matches, res.result == "❌ No match" ? 1 : 0)

push!(results_df, [
step_count,
res.N,
res.parts,
res.multiplied_parts,
res.PQ,
res.NK,
res.result
])

if current_N == 1
@printf("🎉 Reached end of sequence: N = 1\n")
break
end

current_N = collatz_step(current_N)
end

full = full_matches[]
both = partial_both[]
start_only = partial_start[]
end_only = partial_end[]
none = no_matches[]

# Save statistics
println("\n💾 Saving results to CSV...")
CSV.write("collatz_scs_results.csv", results_df)

open("collatz_scs_statistics.txt", "w") do io
write(io, "📊 Collatz Conjecture through SNS\n")
write(io, "=========================================\n")
write(io, "🔢 Starting number: $(string(N)[1:1994])...\n")
write(io, "📐 Number of parts m = $m\n")
write(io, "🧮 Multiplier k = $k\n")
write(io, "-----------------------------------------\n")
write(io, "✅ Full matches: $full\n")
write(io, "🔄 Start and end match: $both\n")
write(io, "🔄 Only start matches: $start_only\n")
write(io, "🔄 Only end matches: $end_only\n")
write(io, "❌ No matches: $none\n")
write(io, "📄 All data — in 'collatz_scs_results.csv'\n")
end

# Print summary stats
println("\n📊 Summary statistics:")
@printf("✅ Full matches: %d\n", full)
@printf("🔄 Start and end match: %d\n", both)
@printf("🔄 Only start matches: %d\n", start_only)
@printf("🔄 Only end matches: %d\n", end_only)
@printf("❌ No matches: %d\n", none)

println("\n📄 Statistics saved to 'collatz_scs_statistics.txt'")
println("📄 Results saved to 'collatz_scs_results.csv'")

return results_df
end

# START THE PROGRAM

println("🎯 Welcome to the Collatz Conjecture Analysis via SNS!")
println("📜 Author: Mikhail Yushchenko | Year 2025")
println("🔢 Algorithm works with all positive integers without limits.")

@printf("🔢 Starting number N = %s\n", string(N_START)[1:1994])
@printf("📐 Number of parts m = %d\n", M_SCS)
@printf("🧮 Multiplier for SNS: %d\n", K_SCS)

# Run SNS analysis at every Collatz step
df = run_collatz_with_scs_analysis(N_START, M_SCS, K_SCS, MAX_ITERATIONS)

println("\n📈 Analysis completed.")