using Printf # Imports the module for formatted output (e.g., @printf)
using CSV # Imports library for working with CSV files
using DataFrames # Imports DataFrame type for tabular storage of results
using Base.Threads # Enables multithreading support
using ProgressMeter # Allows displaying progress of loops

# Function splits number N into m parts as evenly as possible
function split_number_str(N::Integer, m::Integer)
s = string(N)  # Converts number N to a string

if N < 10 # If number is less than 10 — pad with leading zeros up to length m
s = lpad(s, m, '0')  # Add leading zeros to make length m
end

len = length(s)  # Determine total length of the string
base_len = div(len, m)  # Base length per part
remainder = len % m  # Remainder — how many parts will be longer by 1 character

parts = String[]  # Array to store parts of the number
idx = 1  # Current position in the string

for i in 1:m  # Loop over number of parts
current_len = base_len + (i <= remainder ? 1 : 0)  # Calculate length of current part
push!(parts, s[idx:idx+current_len-1])  # Add part to array
idx += current_len  # Move index to start of next part
end

return parts  # Return array of number parts
end

# Multiplies a string part preserving its original length
function multiply_preserve_length(part::String, k::Integer)
num = parse(BigInt, part) * k  # Convert part to number and multiply by k
result = string(num)  # Convert back to string
return lpad(result, length(part), '0')  # Preserve original length with leading zeros
end

# Removes leading zeros from a string
function remove_leading_zeros(s::String)
if all(c -> c == '0', s)  # If entire string is zeros
return "0"  # Return "0"
else
idx = findfirst(c -> c != '0', s)  # Find first non-zero character
return s[idx:end]  # Return string without leading zeros
end
end

# Compares PQ and NK by beginning and end
function compare_pq_nk(pq::String, nk::String)
if pq == nk  # Full match
return "✅ Full match"
end

min_len = min(length(pq), length(nk))  # Minimum length of strings
prefix_match = 0  # Counter for front matches
for i in 1:min_len  # Loop comparing characters from the front
pq[i] == nk[i] ? prefix_match += 1 : break  # Increment or exit
end

suffix_match = 0  # Counter for end matches
for i in 1:min_len  # Loop comparing characters from the end
pq[end - i + 1] == nk[end - i + 1] ? suffix_match += 1 : break  # Increment or exit
end

if prefix_match > 0 && suffix_match > 0  # Both start and end match
return "🔄 Start and end match"
elseif prefix_match > 0  # Only start matches
return "🔄 Only start matches"
elseif suffix_match > 0  # Only end matches
return "🔄 Only end matches"
else  # No matches
return "❌ No match"
end
end

# Checks algorithm for a single number
function check_algorithm(N::Integer, m::Integer, k::Integer)
N_str = string(N)  # Convert N to string
nk_str = string(N * k)  # Multiply N by k and convert to string

parts_str = split_number_str(N, m)  # Split N into m parts
multiplied_parts_str = [multiply_preserve_length(p, k) for p in parts_str]  # Multiply each part
pq_str = join(multiplied_parts_str)  # Join parts back together

# Remove leading zeros before comparison
pq_clean = remove_leading_zeros(pq_str)  # Clean PQ
nk_clean = remove_leading_zeros(nk_str)  # Clean NK

result = compare_pq_nk(pq_clean, nk_clean)  # Compare PQ and NK

return (  # Return named tuple with test results
N = N,  # Original number N
m = m,  # Number of parts N was divided into
k = k,  # Multiplier used on each part
parts = string(parts_str),  # String representation of number split
multiplied_parts = string(multiplied_parts_str),  # String representation of multiplied parts
PQ = pq_clean,  # Concatenated result after multiplication (cleaned of leading zeros)
NK = nk_clean,  # Result of multiplying whole number by k (N * k) (cleaned)
result = result  # Comparison result (full match, partial, etc.)
    )  # Final NamedTuple contains all data for one number N
end

# Parallel testing over range of numbers
function run_tests_parallel(start_N::Integer, stop_N::Integer, m::Integer, k::Integer)
results_df = DataFrame(  # Create DataFrame to store results
N = Int[], # Field "N" — integers
m = Int[], # Field "m" — integers
k = Int[], # Field "k" — integers
parts = String[], # Field "parts" — strings (split parts of original number)
multiplied_parts = String[], # Field "multiplied_parts" — strings (multiplied parts)
PQ = String[], # Field "PQ" — result string after part multiplication
NK = String[], # Field "NK" — string N * k
result = String[] # Field "result" — string describing match status
    )

count_full = Atomic{Int}(0)  # Counter for full matches
count_partial_start = Atomic{Int}(0)  # Only start matches
count_partial_end = Atomic{Int}(0)  # Only end matches
count_partial_both = Atomic{Int}(0)  # Both start and end matches
count_none = Atomic{Int}(0)  # No matches

@showprogress "🚀 Testing N ∈ [$start_N, $stop_N], m = $m, k = $k" for N in start_N:stop_N  # Show progress
res = check_algorithm(N, m, k)  # Run check for specific N

Threads.atomic_add!(count_full, res.result == "✅ Full match" ? 1 : 0)  # Update counters
Threads.atomic_add!(count_partial_start, res.result == "🔄 Only start matches" ? 1 : 0)
Threads.atomic_add!(count_partial_end, res.result == "🔄 Only end matches" ? 1 : 0)
Threads.atomic_add!(count_partial_both, res.result == "🔄 Start and end match" ? 1 : 0)
Threads.atomic_add!(count_none, res.result == "❌ No match" ? 1 : 0)

push!(results_df, [  # Add current N's results to DataFrame
res.N # Original number N
res.m # Number of parts m
res.k # Multiplier k
res.parts # String representation of split parts
res.multiplied_parts  # String representation of multiplied parts
res.PQ # PQ result after joining (cleaned)
res.NK # NK = N * k (cleaned)
res.result # Match result: full, partial, none
        ])
  end

  full = count_full[]
  partial_start = count_partial_start[]
  partial_end = count_partial_end[]
  partial_both = count_partial_both[]
  none = count_none[]

  println("\n💾 Saving results to CSV...") # Save statistics to file
  CSV.write("results.csv", results_df)  # Write results table to CSV file

  open("statistics.txt", "w") do io  # Open file for writing statistics
  write(io, "📊 Structural Numerical Symmetry\n")
  write(io, "=========================================\n")
  write(io, "Range N: [$start_N, $stop_N]\n")
  write(io, "Number of parts m = $m\n")
  write(io, "Multiplier k = $k\n")
  write(io, "-----------------------------------------\n")
  write(io, "  ✅ Full matches: $full\n")
  write(io, "  🔄 Start and end match: $partial_both\n")
  write(io, "  🔄 Only start matches: $partial_start\n")
  write(io, "  🔄 Only end matches: $partial_end\n")
  write(io, "  ❌ No matches: $none\n")
  write(io, "📄 Results for each number are in 'results.csv'\n")
  end

  println("\n📊 Summary statistics:") # Output stats to terminal
  @printf("  ✅ Full matches: %d\n", full)
  @printf("  🔄 Start and end match: %d\n", partial_both)
  @printf("  🔄 Only start matches: %d\n", partial_start)
  @printf("  🔄 Only end matches: %d\n", partial_end)
  @printf("  ❌ No matches: %d\n", none)
  @println("\n📄 Statistics saved to 'statistics.txt'")
  @println("📄 Results saved to 'results.csv'")

return results_df  # Return filled results DataFrame
end

# User parameters
start_N = 1 # Start of test range
stop_N = 10000000 # End of test range
m = 2 # Number of parts to split original number
k = 7 # Multiplier applied to each part

# Run tests
run_tests_parallel(start_N, stop_N, m, k)  # Call main function to test SNS
