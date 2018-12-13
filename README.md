# Advent of Code 2017

[![Build Status](https://travis-ci.org/sevenseacat/advent_of_code_2017.svg?branch=master)](https://travis-ci.org/sevenseacat/advent_of_code_2017)

My Elixir solutions for the [Advent of Code 2017](http://adventofcode.com/2017).

## Runtimes

If you're curious how long each of the solutions roughly takes to run.

```
Name                    ips        average  deviation         median         99th %
day 1, part 1        2.75 K      363.98 μs   ±113.62%         300 μs     1180.65 μs
day 1, part 2        3.06 K      327.21 μs    ±23.83%         304 μs         612 μs

Name                    ips        average  deviation         median         99th %
day 2, part 1        3.90 K      256.27 μs    ±43.24%         248 μs         417 μs
day 2, part 2        2.56 K      390.99 μs    ±60.73%         337 μs     1394.44 μs

Name                    ips        average  deviation         median         99th %
day 3, part 1         10.13       98.68 ms    ±16.53%       97.08 ms      161.06 ms
day 3, part 2         86.72       11.53 ms    ±25.03%       11.20 ms       22.32 ms

Name                    ips        average  deviation         median         99th %
day 4, part 1        202.00        4.95 ms     ±5.57%        4.92 ms        6.07 ms
day 4, part 2        140.95        7.09 ms     ±8.58%        6.93 ms       10.54 ms

Name                    ips        average  deviation         median         99th %
day 5, part 1          6.23        0.161 s    ±13.62%        0.150 s         0.24 s
day 5, part 2        0.0891        11.22 s     ±0.00%        11.22 s        11.22 s

Name                    ips        average  deviation         median         99th %
day 6, parts 1+2       5.63      177.56 ms    ±18.51%      163.60 ms      283.72 ms

Name                    ips        average  deviation         median         99th %
day 7, part 1          7.58      131.95 ms    ±10.21%      128.23 ms      179.93 ms
day 7, part 2          4.00      250.03 ms    ±15.04%      235.25 ms      372.73 ms

Name                    ips        average  deviation         median         99th %
day 8, part 1        183.00        5.46 ms    ±27.70%        5.08 ms        9.76 ms
day 8, part 2        129.13        7.74 ms    ±18.67%        7.30 ms       14.77 ms

Name                    ips        average  deviation         median         99th %
day 9, parts 1+2     210.79        4.74 ms    ±44.85%        4.06 ms       13.43 ms

Name                    ips        average  deviation         median         99th %
day 10, part 1       1.30 K        0.77 ms    ±68.83%        0.67 ms        2.10 ms
day 10, part 2     0.0157 K       63.71 ms    ±15.19%       59.48 ms      104.60 ms

Name                    ips        average  deviation         median         99th %
day 11, part 1       486.99        2.05 ms    ±52.68%        1.83 ms        4.72 ms
day 11, part 2       367.00        2.72 ms    ±68.03%        2.19 ms       11.51 ms

Name                    ips        average  deviation         median         99th %
day 12, part 1        13.15       76.04 ms    ±24.01%       68.94 ms      161.47 ms
day 12, part 2         1.01      988.70 ms    ±12.41%      939.11 ms     1151.66 ms

Name                    ips        average  deviation         median         99th %
day 13, part 1       1.48 K        0.68 ms    ±26.92%        0.63 ms        1.36 ms
day 13, part 2    0.00105 K      954.36 ms     ±0.25%      953.64 ms      958.28 ms

Name                    ips        average  deviation         median         99th %
day 14, part 1         0.25         4.05 s    ±11.49%         4.05 s         4.38 s
day 14, part 2        0.159         6.28 s     ±0.00%         6.28 s         6.28 s

Name                    ips        average  deviation         median         99th %
day 15, part 1        0.138         7.27 s     ±0.00%         7.27 s         7.27 s
day 15, part 2         0.31         3.25 s     ±1.34%         3.25 s         3.29 s

Name                    ips        average  deviation         median         99th %
day 16, part 1        64.75       15.44 ms    ±44.71%       13.36 ms       47.63 ms
day 16, part 2         5.11      195.79 ms     ±8.60%      191.23 ms      255.49 ms

Name                    ips        average  deviation         median         99th %
day 17, part 1        58.58       0.0171 s     ±4.28%       0.0169 s       0.0210 s
day 17, part 2         0.73         1.37 s     ±0.19%         1.37 s         1.38 s

Name                    ips        average  deviation         median         99th %
day 18, part 1       1.39 K        0.72 ms    ±63.04%        0.59 ms        2.23 ms
day 18, part 2    0.00164 K      611.52 ms    ±12.46%      571.02 ms      741.52 ms

Name                    ips        average  deviation         median         99th %
day 19, part 1        53.59       18.66 ms    ±46.89%       15.63 ms       56.02 ms
day 19, part 2        54.80       18.25 ms    ±29.09%       16.50 ms       40.19 ms

Name                    ips        average  deviation         median         99th %
day 20, part 1       108.09        9.25 ms    ±37.13%        8.33 ms       27.47 ms
day 20, part 2         2.14      468.15 ms    ±13.18%      435.85 ms      591.33 ms

Name                    ips        average  deviation         median         99th %
day 21, part 1       150.27      0.00665 s    ±34.75%      0.00573 s       0.0168 s
day 21, part 2        0.172         5.82 s     ±0.00%         5.82 s         5.82 s

Name                    ips        average  deviation         median         99th %
day 22, part 1       104.00      0.00962 s    ±31.00%      0.00889 s       0.0225 s
day 22, part 2       0.0827        12.10 s     ±0.00%        12.10 s        12.10 s

Name                    ips        average  deviation         median         99th %
day 23, part 1        55.87       17.90 ms    ±23.42%       16.57 ms       37.59 ms
day 23, part 2       121.01        8.26 ms    ±33.59%        7.18 ms       18.90 ms

Name                    ips        average  deviation         median         99th %
day 24, part 1        0.137         7.29 s     ±0.00%         7.29 s         7.29 s
day 24, part 2        0.195         5.14 s     ±0.00%         5.14 s         5.14 s

Name                    ips        average  deviation         median         99th %
day 25, part 1        0.166         6.04 s     ±0.00%         6.04 s         6.04 s
```

🎄
