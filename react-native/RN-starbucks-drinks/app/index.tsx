import Coffee from "@/components/Coffee";
import CoffeeInfo from "@/components/CoffeeInfo";
import { INFO_ITEM_HIEGHT, ITEM_WIDTH, width } from "@/constants";
import Colors from "@/constants/Colors";
import Font from "@/constants/Font";
import FontSize from "@/constants/FontSize";
import Spacing from "@/constants/Spacing";
import { Coffee as CoffeeType, starbucksData } from "@/data";
import React from "react";
import { SafeAreaView, Text, TouchableOpacity, View } from "react-native";
import Animated, {
  scrollTo,
  useAnimatedRef,
  useAnimatedScrollHandler,
  useDerivedValue,
  useSharedValue,
  withSpring,
} from "react-native-reanimated";

const Home = () => {
  const scrollX = useSharedValue(0);
  const scrollYOffset = useSharedValue(0);
  const scrollViewRef = useAnimatedRef<Animated.ScrollView>();

  const scrollHandler = useAnimatedScrollHandler((event) => {
    const scrollXOffset = event.contentOffset.x;
    scrollX.value = scrollXOffset;

    const activeIndex = scrollXOffset / ITEM_WIDTH;
    const scrollY = activeIndex * (INFO_ITEM_HIEGHT - Spacing * 7);
    scrollYOffset.value = withSpring(scrollY);
  });

  useDerivedValue(() => scrollTo(scrollViewRef, 0, scrollYOffset.value, false));

  return (
    <SafeAreaView>
      <View style={{ paddingVertical: Spacing * 4 }}>
        <Animated.FlatList
          onScroll={scrollHandler}
          style={{ overflow: "visible" }}
          horizontal
          bounces={false}
          showsHorizontalScrollIndicator={false}
          snapToInterval={ITEM_WIDTH}
          decelerationRate={0}
          data={[{ id: "left-space" }, ...starbucksData, { id: "right-space" }]}
          renderItem={({ item, index }) => {
            if (item.id === "left-space" || item.id === "right-space")
              return <View style={{ width: (width - ITEM_WIDTH) / 2 }} />;
            else
              return (
                <Coffee
                  item={item as CoffeeType}
                  index={index}
                  scrollX={scrollX}
                />
              );
          }}
        />

        <View
          style={{
            backgroundColor: Colors.white,
            borderRadius: Spacing * 3,
            height: INFO_ITEM_HIEGHT,
            marginHorizontal: Spacing * 2,
            overflow: "hidden",
            marginTop: -Spacing * 3,
            zIndex: -1,
          }}
        >
          <Animated.ScrollView
            bounces={false}
            ref={scrollViewRef}
            showsVerticalScrollIndicator={false}
            decelerationRate={0}
            snapToInterval={INFO_ITEM_HIEGHT - Spacing * 7}
            scrollEnabled={false}
          >
            {starbucksData.map((item) => (
              <CoffeeInfo key={item.id} item={item} />
            ))}
          </Animated.ScrollView>
          <TouchableOpacity
            style={{
              marginHorizontal: Spacing * 2,
              backgroundColor: Colors.black,
              paddingHorizontal: Spacing * 3,
              borderRadius: Spacing * 3,
              marginBottom: Spacing * 2,
              justifyContent: "center",
              alignItems: "center",
              height: Spacing * 5,
              shadowOffset: {
                width: 5,
                height: 5,
              },
              shadowOpacity: 0.3,
              shadowColor: Colors.black,
            }}
          >
            <Text
              style={{
                color: Colors.white,
                fontSize: FontSize.large,
                fontFamily: Font["poppins-semiBold"],
              }}
            >
              Get it
            </Text>
          </TouchableOpacity>
        </View>
      </View>
    </SafeAreaView>
  );
};

export default Home;
