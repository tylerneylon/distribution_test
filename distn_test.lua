-- distn_test.lua
--
-- Empirically test an idea for generating sorted random numbers in linear
-- time. This problem 29 from section 3.4.1 of The Art of Computer Programming,
-- 3rd edition, by Donald Knuth
--

-- This expects all samples to live in [0, 1].
function draw_hist(samples)
  local w, h = 180, 47
  local x_left = 0
  local x_delta = 1.0 / w

  -- Determine number of samples per bucket.
  local buckets = {}
  local max_size = 0
  for _, sample in pairs(samples) do
    assert(0 <= sample and sample <= 1)
    local b = math.floor(sample / x_delta) + 1
    -- Special case: Put each sample == 1.0 in the rightmost bucket.
    if b > w then b = w end
    buckets[b] = (buckets[b] or 0) + 1
    if buckets[b] > max_size then
      max_size = buckets[b]
    end
  end

  -- Draw the histogram.
  for line = 1, h do
    io.write((line == 1 and 'T ' or '| '))
    for col = 1, w do
      local cutoff = (h - line) / h * max_size
      local c = ' '
      if (buckets[col] or 0) > cutoff then
        c = 'X'
      end
      io.write(c)
    end
    io.write('\n')
  end
  io.write('\\ ')
  for col = 1, w do
    io.write('_')
  end
  print('')
end

function draw_x_squared_hist()
  -- This histogram should look like
  -- 1/2 x^(-1/2).
  local samples = {}
  for i = 1, 1000000 do
    local x = math.random()
    table.insert(samples, x * x)
  end
  draw_hist(samples)
end

-- This chooses n random uniforms in [0, 1] and then returns the kth biggest.
function get_kth_place(k, n)
  assert(1 <= k and k <= n)
  local s = {}
  for i = 1, n do
    s[#s + 1] = math.random()
  end
  table.sort(s)
  if k < 0 then
    k = k + 1 + n
  end
  return s[k]
end

-- TODO Try multiplying somethere here by (n choose k).

function get_simulated_kth_place(k, n)
  assert(1 <= k and k <= n)
  local s = {}
  local a = 1
  for i = n, 1, -1 do
    local x = (math.random() ^ (1/i)) * a
    a = x
    s[#s + 1] = x
  end
  -- Note that s is sorted with largest-first here.
  return s[n + 1 - k]
end

function draw_x_max_hist(n)
  local num_samples = 1000000
  local samples = {}
  for i = 1, num_samples do
    table.insert(samples, get_kth_place(n, n))
  end
  draw_hist(samples)
end

function draw_kth_place_hist(k, n)
  local num_samples = 1000000
  local samples = {}
  for i = 1, num_samples do
    table.insert(samples, get_kth_place(k, n))
  end
  draw_hist(samples)
end

function draw_simulated_kth_place_hist(k, n)
  local num_samples = 1000000
  --local num_samples = 1000
  local samples = {}
  for i = 1, num_samples do
    table.insert(samples, get_simulated_kth_place(k, n))
  end
  draw_hist(samples)
end

-- This should look like y = 2x.
-- draw_x_max_hist(2)

--[[

In general, P(x_max ≤ w) = w^n, so pdf p(x_max = w) = nw^(n-1).
So I'd expect the curve of draw_x_max_hist(n) to have the shape:

    y = n * x ^ (n - 1)

--]]

local N = 7
for k = 1, N do
  print(('\nk/N = %d/%d:'):format(k, N))
  --draw_kth_place_hist(k, N)
  draw_simulated_kth_place_hist(k, N)
end
