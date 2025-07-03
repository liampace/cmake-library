#include <gtest/gtest.h>
#include <MyLibrary.h>

TEST(Example, Pass)
{
	ASSERT_TRUE(true);
}

TEST(Example, Fail)
{
	ASSERT_TRUE(false);
}