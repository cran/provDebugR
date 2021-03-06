library(testthat)
library(provDebugR)

context("debug.lineage")

# === HELPER FUNCTIONS ======================================================= #

# helper function to get expected output for backward lineages
# uses test case: fromEnv
get.expected.backward <- function()
{
	# no backwards lineage for a and b (fromEnv variales)
	
	# index 1: d
	d <- data.frame(scriptNum = 1L,
					scriptName = "console",
					startLine = 1L,
					code = 'd <- 10',
					stringsAsFactors = FALSE)
	
	# index 2: vector.1
	vector.1 <- data.frame(scriptNum = as.integer(c(1,1)),
						   scriptName = rep("console", 2),
						   startLine = as.integer(c(1,2)),
						   code = c('d <- 10', 'vector.1 <- c(a:d)'),
						   stringsAsFactors = FALSE)
	
	# index 3: output
	output <- data.frame(scriptNum = 1L,
						 scriptName = "console",
						 startLine = 29L,
						 code = 'print("End of script!")',
						 stringsAsFactors = FALSE)
	
	# index 4: e
	e <- data.frame(scriptNum = 1L,
					scriptName = "console",
					startLine = 5L,
					code = 'e <- a + 10',
					stringsAsFactors = FALSE)
	
	# index 5: f
	f <- data.frame(scriptNum = as.integer(c(1,1)),
					scriptName = rep("console", 2),
					startLine = as.integer(c(1,6)),
					code = c('d <- 10', 'f <- d + 10'),
					stringsAsFactors = FALSE)
	
	# index 6: vector.2
	# omit code column
	vector.2 <- data.frame(scriptNum = rep(1L,4),
						   scriptName = rep("console", 4),
						   startLine = as.integer(c(1,5,6,7)),
						   stringsAsFactors = FALSE)
	
	# index 7: dev.2
	# omit code column
	dev.2 <- data.frame(scriptNum = rep(1L,10),
						scriptName = rep("console", 10),
						startLine = as.integer(c(1,2,5,6,7,17,18,19,20,21)),
						stringsAsFactors = FALSE)
	
	# index 8: dev.off.12.pdf
	# omit code column
	dev.off.12.pdf <- data.frame(scriptNum = rep(1L,9),
								 scriptName = rep("console", 9),
								 startLine = as.integer(c(1,2,5,6,7,11,12,13,14)),
								 stringsAsFactors = FALSE)
	
	# index 9: vector.3
	# omit code column
	vector.3 <- data.frame(scriptNum = rep(1L,3),
						   scriptName = rep("console", 3),
						   startLine = as.integer(c(1,2,18)),
						   stringsAsFactors = FALSE)
	
	# index 10: vector.4
	# omit code column
	vector.4 <- data.frame(scriptNum = rep(1L,5),
						   scriptName = rep("console", 5),
						   startLine = as.integer(c(1,5,6,7,19)),
						   stringsAsFactors = FALSE)
	
	# index 11: plot.pdf
	# omit code column
	plot.pdf <- data.frame(scriptNum = rep(1L,11),
						   scriptName = rep("console", 11),
						   startLine = as.integer(c(1,2,5,6,7,17,18,19,20,21,22)),
						   stringsAsFactors = FALSE)
	
	# index 12: g
	g <- data.frame(scriptNum = 1L,
					scriptName = "console",
					startLine = 25L,
					code = 'g <- b + 50',
					stringsAsFactors = FALSE)
	
	# combine into list
	expected <- list(d, vector.1, output, e, f, vector.2, dev.2,
					 dev.off.12.pdf, vector.3, vector.4, plot.pdf, g)
	names(expected) <- c("d", "vector.1", "output", "e", "f", "vector.2", "dev.2",
						 "dev.off.12.pdf", "vector.3", "vector.4", "plot.pdf", "g")
	
	return(expected)
}

# helper function to get expected output for forward lineages
# uses test case: fromEnv
get.expected.forward <- function()
{
	# no lineage for output
	
	# index 1: d
	# omit code column
	d <- data.frame(scriptNum = rep(1L,14),
					scriptName = rep("console", 14),
					startLine = as.integer(c(1,2,3,6,7,8,12,13,14,18,19,20,21,22)),
					stringsAsFactors = FALSE)
	
	# index 2: a
	# omit code column
	a <- data.frame(scriptNum = rep(1L,13),
					scriptName = rep("console", 13),
					startLine = as.integer(c(2,3,5,7,8,12,13,14,18,19,20,21,22)),
					stringsAsFactors = FALSE)
	
	# index 3: vector.1
	# omit code column
	vector.1 <- data.frame(scriptNum = rep(1L,9),
						   scriptName = rep("console", 9),
						   startLine = as.integer(c(2,3,12,13,14,18,20,21,22)),
						   stringsAsFactors = FALSE)
	
	# index 4: output
	output <- data.frame(scriptNum = 1L,
						 scriptName = "console",
						 startLine = 3L,
						 code = 'print(vector.1)',
						 stringsAsFactors = FALSE)
	
	# index 5: e
	# omit code column
	e <- data.frame(scriptNum = rep(1L,10),
					scriptName = rep("console", 10),
					startLine = as.integer(c(5,7,8,12,13,14,19,20,21,22)),
					stringsAsFactors = FALSE)
	
	# index 6: f
	# omit code column
	f <- data.frame(scriptNum = rep(1L,10),
					scriptName = rep("console", 10),
					startLine = as.integer(c(6,7,8,12,13,14,19,20,21,22)),
					stringsAsFactors = FALSE)
	
	# index 7: vector.2
	# omit code column
	vector.2 <- data.frame(scriptNum = rep(1L,9),
						   scriptName = rep("console", 9),
						   startLine = as.integer(c(7,8,12,13,14,19,20,21,22)),
						   stringsAsFactors = FALSE)
	
	# index 8: dev.2
	# omit code column
	dev.2 <- data.frame(scriptNum = rep(1L,4),
						scriptName = rep("console", 4),
						startLine = as.integer(c(11,12,13,14)),
						stringsAsFactors = FALSE)
	
	# index 9: dev.off.12.pdf
	dev.off.12.pdf <- data.frame(scriptNum = 1L,
								 scriptName = "console",
								 startLine = 14L,
								 code = 'dev.off()',
								 stringsAsFactors = FALSE)
	
	# index 10: vector.3
	# omit code column
	vector.3 <- data.frame(scriptNum = rep(1L,4),
						   scriptName = rep("console", 4),
						   startLine = as.integer(c(18,20,21,22)),
						   stringsAsFactors = FALSE)
	
	# index 11: vector.4
	# omit code column
	vector.4 <- data.frame(scriptNum = rep(1L,4),
						   scriptName = rep("console", 4),
						   startLine = as.integer(c(19,20,21,22)),
						   stringsAsFactors = FALSE)
	
	# index 12: plot.pdf
	plot.pdf <- data.frame(scriptNum = 1L,
						   scriptName = "console",
						   startLine = 22L,
						   code = 'dev.off()',
						   stringsAsFactors = FALSE)
	
	# index 13: b
	b <- data.frame(scriptNum = as.integer(c(1,1)),
					scriptName = rep("console", 2),
					startLine = as.integer(c(25,26)),
					code = c('g <- b + 50', 'print(g)'),
					stringsAsFactors = FALSE)
	
	# index 14: g
	# identical to b
	g <- data.frame(scriptNum = as.integer(c(1,1)),
					scriptName = rep("console", 2),
					startLine = as.integer(c(25,26)),
					code = c('g <- b + 50', 'print(g)'),
					stringsAsFactors = FALSE)
	
	# combine into list
	expected <- list(d, a, vector.1, output, e, f, vector.2, dev.2,
					 dev.off.12.pdf, vector.3, vector.4, plot.pdf, b, g)
	names(expected) <- c("d", "a", "vector.1", "output", "e", "f", "vector.2", "dev.2",
						 "dev.off.12.pdf", "vector.3", "vector.4", "plot.pdf", "b", "g")
	
	return(expected)
}

# === THE TESTS ============================================================== #

# no provenance
test_that("debug.lineage - no/empty provenance", 
{
	# clean debug environment of provDebugR first to ensure inital state
	provDebugR:::.clear()
	
	# initialisation not run
	expect_false(provDebugR:::.debug.env$has.graph)
	expect_error(provDebugR::debug.lineage("x"))
	
	# empty provenance
	c0 <- system.file("testdata", "empty.json", package = "provDebugR")
	expect_error(provDebugR::prov.debug.file(c0))
	expect_false(provDebugR:::.debug.env$has.graph)
	expect_error(provDebugR::debug.lineage("x"))
})

# no data nodes
test_that("debug.lineage - no data nodes",
{
	skip("debug.lineage - no data nodes")
	
	json <- system.file("testdata", "noDataNodes.json", package = "provDebugR")
	
	provDebugR:::.clear()
	expect_warning(prov.debug.file(json))   # warning is due to deleted prov folder
	
	c2 <- utils::capture.output(c1 <- debug.variable(all = TRUE))
	
	expect_null(c1)
	expect_true(nchar(paste(c2, collapse='\n')) > 0)
})


# debug.lineage tests
json <- system.file("testdata", "fromEnv.json", package = "provDebugR")

provDebugR:::.clear()
expect_warning(prov.debug.file(json))   # warning is due to deleted prov folder

e.backward <- get.expected.backward()
e.forward <- get.expected.forward()

# debug.lineage - all (backward)
test_that("debug.lineage - all (backward)",
{
	# all
	c2 <- utils::capture.output(
		c1 <- debug.lineage(all = TRUE))
	
	c1$`vector.2` <- c1$`vector.2`[ , -4]   # omit code columns from test
	c1$`dev.2` <- c1$`dev.2`[ , -4]
	c1$`dev.off.12.pdf` <- c1$`dev.off.12.pdf`[ , -4]
	c1$`vector.3` <- c1$`vector.3`[ , -4]
	c1$`vector.4` <- c1$`vector.4`[ , -4]
	c1$`plot.pdf` <- c1$`plot.pdf`[ , -4]
	
	expect_equivalent(c1, e.backward)
	expect_true(nchar(paste(c2, collapse='\n')) > 0)
	
	
	# with a name queries (no lineage, valid, invalid)
	c4 <- utils::capture.output(
		c3 <- debug.lineage("a", "d", "invalid", all = TRUE))
	
	c3$`vector.2` <- c3$`vector.2`[ , -4]   # omit code columns from test
	c3$`dev.2` <- c3$`dev.2`[ , -4]
	c3$`dev.off.12.pdf` <- c3$`dev.off.12.pdf`[ , -4]
	c3$`vector.3` <- c3$`vector.3`[ , -4]
	c3$`vector.4` <- c3$`vector.4`[ , -4]
	c3$`plot.pdf` <- c3$`plot.pdf`[ , -4]
	
	expect_equivalent(c3, e.backward)
	expect_true(nchar(paste(c4, collapse='\n')) > 0)
	
	
	# start line query (valid)
	c5 <- debug.lineage(start.line = 12, all = TRUE)[[1]]
	c5 <- c5[ , -4]   # omit code column
	
	e5 <- e.backward$`dev.off.12.pdf`[c(1:7), ]
	
	expect_equivalent(c5, e5)
	
	
	# start line query (invalid)
	c7 <- utils::capture.output(
		c6 <- debug.lineage(start.line = 100, all = TRUE))
	
	expect_null(c6)
	expect_true(nchar(paste(c7, collapse='\n')) > 0)
	
	
	# start line query (multiple)
	c9 <- utils::capture.output(
		c8 <- debug.lineage(start.line = c(1,2), all = TRUE))
	
	e8 <- e.backward[c(1,2)]
	
	expect_equivalent(c8, e8)
	expect_true(nchar(paste(c9, collapse='\n')) > 0)
	
	
	# script num query (valid)
	c11 <- utils::capture.output(
		c10 <- debug.lineage(script.num = 1, all = TRUE))
	
	c10$`vector.2` <- c10$`vector.2`[ , -4]   # omit code columns from test
	c10$`dev.2` <- c10$`dev.2`[ , -4]
	c10$`dev.off.12.pdf` <- c10$`dev.off.12.pdf`[ , -4]
	c10$`vector.3` <- c10$`vector.3`[ , -4]
	c10$`vector.4` <- c10$`vector.4`[ , -4]
	c10$`plot.pdf` <- c10$`plot.pdf`[ , -4]
	
	expect_equivalent(c10, e.backward)
	expect_true(nchar(paste(c11, collapse='\n')) > 0)
	
	
	# script num query (invalid)
	c13 <- utils::capture.output(
		c12 <- debug.lineage(script.num = 100, all = TRUE))
	
	expect_null(c12)
	expect_true(nchar(paste(c13, collapse='\n')) > 0)
	
	
	# script num query (multiple)
	c15 <- utils::capture.output(
		c14 <- debug.lineage(start.line = c(1,2), script.num = c(1,2), all = TRUE))
	
	e14 <- e.backward[c(1,2)]
	
	expect_equivalent(c14, e14)
	expect_true(nchar(paste(c15, collapse='\n')) > 0)
})

# debug.lineage - all (forward)
test_that("debug.lineage - all (forward)",
{
	# all
	c1 <- debug.lineage(all = TRUE, forward = TRUE)
	
	c1$a <- c1$a[ , -4]   # omit code columns from testing
	c1$d <- c1$d[ , -4]
	c1$e <- c1$e[ , -4]
	c1$f <- c1$f[ , -4]
	c1$`dev.2` <- c1$`dev.2`[ , -4]
	c1$`vector.1` <- c1$`vector.1`[ , -4]
	c1$`vector.2` <- c1$`vector.2`[ , -4]
	c1$`vector.3` <- c1$`vector.3`[ , -4]
	c1$`vector.4` <- c1$`vector.4`[ , -4]
	
	expect_equivalent(c1, e.forward)
	
	
	# with a name queries (no lineage, valid, invalid)
	c2 <- debug.lineage("output", "a", "invalid", all = TRUE, forward = TRUE)
	
	c2$a <- c2$a[ , -4]   # omit code columns from testing
	c2$d <- c2$d[ , -4]
	c2$e <- c2$e[ , -4]
	c2$f <- c2$f[ , -4]
	c2$`dev.2` <- c2$`dev.2`[ , -4]
	c2$`vector.1` <- c2$`vector.1`[ , -4]
	c2$`vector.2` <- c2$`vector.2`[ , -4]
	c2$`vector.3` <- c2$`vector.3`[ , -4]
	c2$`vector.4` <- c2$`vector.4`[ , -4]
	
	expect_equivalent(c2, e.forward)
	
	
	# start line query (valid)
	c3 <- debug.lineage(start.line = 19, all = TRUE, forward = TRUE)[[1]]
	c3 <- c3[ , -4]   # omit code column from testing
	
	e3 <- e.forward$`vector.4`
	expect_equivalent(c3, e3)
	
	
	# start line query (invalid)
	c5 <- utils::capture.output(
		c4 <- debug.lineage(start.line = 100, all = TRUE, forward = TRUE))
	
	expect_null(c4)
	expect_true(nchar(paste(c5, collapse='\n')) > 0)
	
	
	# start line query (multiple)
	c6 <- debug.lineage(start.line = c(18,19), all = TRUE, forward = TRUE)
	
	c6$`vector.3` <- c6$`vector.3`[ , -4]   # omit code columns from testing
	c6$`vector.4` <- c6$`vector.4`[ , -4]
	
	e6 <- e.forward[c(10,11)]
	expect_equivalent(c6, e6)
	
	
	# script num query (valid)
	c7 <- debug.lineage(script.num = 1, all = TRUE, forward = TRUE)
	
	c7$a <- c7$a[ , -4]   # omit code columns from testing
	c7$d <- c7$d[ , -4]
	c7$e <- c7$e[ , -4]
	c7$f <- c7$f[ , -4]
	c7$`dev.2` <- c7$`dev.2`[ , -4]
	c7$`vector.1` <- c7$`vector.1`[ , -4]
	c7$`vector.2` <- c7$`vector.2`[ , -4]
	c7$`vector.3` <- c7$`vector.3`[ , -4]
	c7$`vector.4` <- c7$`vector.4`[ , -4]
	
	expect_equivalent(c7, e.forward)
	
	
	# script num query (invalid)
	c9 <- utils::capture.output(
		c8 <- debug.lineage(script.num = 100, all = TRUE, forward = TRUE))
	
	expect_null(c8)
	expect_true(nchar(paste(c9, collapse='\n')) > 0)
	
	
	# script num query (multiple)
	c10 <- debug.lineage(script.num = c(1:2), all = TRUE, forward = TRUE)
	
	c10$a <- c10$a[ , -4]   # omit code columns from testing
	c10$d <- c10$d[ , -4]
	c10$e <- c10$e[ , -4]
	c10$f <- c10$f[ , -4]
	c10$`dev.2` <- c10$`dev.2`[ , -4]
	c10$`vector.1` <- c10$`vector.1`[ , -4]
	c10$`vector.2` <- c10$`vector.2`[ , -4]
	c10$`vector.3` <- c10$`vector.3`[ , -4]
	c10$`vector.4` <- c10$`vector.4`[ , -4]
	
	expect_equivalent(c10, e.forward)
})

# debug.lineage - name queries (backward)
test_that("debug.lineage - name queries (backward)",
{
	# valid
	c1 <- debug.lineage(f)[[1]]
	e1 <- e.backward$f
	
	expect_equivalent(c1, e1)
	
	# invalid
	c3 <- utils::capture.output(c2 <- debug.lineage("invalid"))
	
	expect_null(c2)
	expect_true(nchar(paste(c3, collapse='\n')) > 0)
	
	# no backward lineage
	c5 <- utils::capture.output(c4 <- debug.lineage("a"))
	
	expect_null(c4)
	expect_true(nchar(paste(c5, collapse='\n')) > 0)
	
	# multiple queries
	c7 <- utils::capture.output(
		c6 <- debug.lineage("a", f, "invalid.1", "e", "invalid.2"))
	
	e6 <- e.backward[c(5,4)]
	
	expect_equivalent(c6, e6)
	expect_true(nchar(paste(c7, collapse='\n')) > 0)
	
	# valid name query, but invalid number
	c9 <- utils::capture.output(
		c8 <- debug.lineage("f", start.line = 10))
	
	expect_null(c8)
	expect_true(nchar(paste(c9, collapse='\n')) > 0)
})

# debug.lineage - name queries (forward)
test_that("debug.lineage - name queries (forward)",
{
	# valid
	c1 <- debug.lineage(b, forward = TRUE)[[1]]
	e1 <- e.forward$b
	
	expect_equivalent(c1, e1)
	
	# invalid
	c3 <- utils::capture.output(
		c2 <- debug.lineage("invalid", forward = TRUE))
	
	expect_null(c2)
	expect_true(nchar(paste(c3, collapse='\n')) > 0)
	
	# multiple queries (valid, invalid)
	c4 <- debug.lineage("b", "invalid", output, forward = TRUE)
	
	e4 <- e.forward[c(13,4)]
	
	expect_equivalent(e4, c4)
	
	# valid query, invalid start line
	c6 <- utils::capture.output(
		c5 <- debug.lineage("b", start.line = 50))
	
	expect_null(c5)
	expect_true(nchar(paste(c6, collapse='\n')) > 0)
})

# debug.lineage - start line queries (backward)
test_that("debug.lineage - start line queries (backward)",
{
	# valid
	c1 <- debug.lineage("f", start.line = 6)[[1]]
	e1 <- e.backward$f
	
	expect_equivalent(c1, e1)
	
	# invalid
	c3 <- utils::capture.output(
		c2 <- debug.lineage("f", start.line = 100))
	
	expect_null(c2)
	expect_true(nchar(paste(c3, collapse='\n')) > 0)
	
	# multiple
	c4 <- debug.lineage("e", "f", start.line = c(5,6))
	e4 <- e.backward[c(4,5)]
	
	expect_equivalent(c4, e4)
	
	# neither the first nor last instance of variable
	c5 <- debug.lineage("dev.2", start.line = 20)[[1]]
	c5 <- c5[ , -4]   # omit code column from comparison
	
	e5 <- data.frame(scriptNum = rep(1L,9),
					 scriptName = rep("console", 9),
					 startLine = as.integer(c(1,2,5,6,7,17,18,19,20)),
					 stringsAsFactors = FALSE)
	
	expect_equivalent(c5, e5)
})

# debug.lineage - start line queries (forward)
test_that("debug.lineage - start line queries (forward)",
{
	# valid
	c1 <- debug.lineage("b", start.line = 25, forward = TRUE)[[1]]
	e1 <- e.forward$b
	
	expect_equivalent(c1, e1)
	
	
	# invalid
	c3 <- utils::capture.output(
		c2 <- debug.lineage("b", start.line = 50, forward = TRUE))
	
	expect_null(c2)
	expect_true(nchar(paste(c3, collapse='\n')) > 0)
	
	
	# multiple
	c4 <- debug.lineage("output", "g", start.line = c(3,25), forward = TRUE)
	e4 <- e.forward[c(4,14)]
	
	expect_equivalent(c4, e4)
	
	
	# neither the first nor last instance of variable
	c5 <- debug.lineage("dev.2", start.line = 12, forward = TRUE)[[1]]
	c5 <- c5[ , -4]   # omit code column from comparison
	
	e5 <- data.frame(scriptNum = rep(1L,3),
					 scriptName = rep("console", 3),
					 startLine = as.integer(c(12,13,14)),
					 stringsAsFactors = FALSE)
	
	expect_equivalent(c5, e5)
})

# debug.lineage - script num queries (backward)
test_that("debug.lineage - script num queries (backward)",
{
	# valid
	c1 <- debug.lineage("e", "f", script.num = 1)
	e1 <- e.backward[c(4,5)]
	
	expect_equivalent(c1, e1)
	
	
	# invalid
	c3 <- utils::capture.output(
		c2 <- debug.lineage("output", script.num = 2))
	
	expect_null(c2)
	expect_true(nchar(paste(c3, collapse='\n')) > 0)
	
	
	# multiple
	c4 <- debug.lineage("f", script.num = c(1,2))[[1]]
	e4 <- e.backward$f
	
	expect_equivalent(c4, e4)
})

# debug.lineage - script num queries (forward)
test_that("debug.lineage - script num queries (forward)",
{
	# valid
	c1 <- debug.lineage(b, g, script.num = 1, forward = TRUE)
	e1 <- e.forward[c(13,14)]
	
	expect_equivalent(c1, e1)
	
	
	# invalid
	c3 <- utils::capture.output(
		c2 <- debug.lineage("output", script.num = 2, forward = TRUE))
	
	expect_null(c2)
	expect_true(nchar(paste(c3, collapse='\n')) > 0)
	
	
	# multiple
	c4 <- debug.lineage(b, script.num = c(1,2), forward = TRUE)[[1]]
	e4 <- e.forward$b
	
	expect_equivalent(c4, e4)
})


# get lineage tests (esp forward tests)
# .get.lineage - backward lineage
test_that(".get.lineage - backward lineage",
{	
	# valid (includes a fromEnv variable)
	c1 <- provDebugR:::.get.lineage("d3")
	e1 <- c("p3", "p4")
	
	expect_equivalent(c1, e1)
	
	
	# no backwards lineage
	c2 <- provDebugR:::.get.lineage("d2")
	expect_null(c2)
	
	
	# lineage with only 1 proc node
	c3 <- provDebugR:::.get.lineage("d20")
	expect_equivalent(c3, "p20")
	
	
	# non-assignment with lineage of 1 node
	c4 <- provDebugR:::.get.lineage("d22")
	expect_equivalent(c4, "p22")
})

# .get.lineage - forward lineage
test_that(".get.lineage - forward lineage",
{
	# valid
	c1 <- provDebugR:::.get.lineage("d15", forward = TRUE)
	e1 <- c("p16", "p17", "p18", "p19")
	
	expect_equivalent(c1, e1)
	
	
	# valid (a fromEnv variable)
	c2 <- provDebugR:::.get.lineage("d19", forward = TRUE)
	e2 <- c("p20", "p21")
	
	expect_equivalent(c2, e2)
	
	
	# non-assignment with no proc nodes following it
	c3 <- provDebugR:::.get.lineage("d4", forward = TRUE)
	expect_equivalent(c3, "p5")
})
