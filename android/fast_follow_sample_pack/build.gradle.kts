// https://developer.android.com/guide/playcore/asset-delivery/integrate-java#kts
plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("fast_follow_sample_pack")
    dynamicDelivery {
        deliveryType.set("fast-follow")
    }
}