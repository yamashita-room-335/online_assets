// https://developer.android.com/guide/playcore/asset-delivery/integrate-java#kts
plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("on_demand_sample_pack")
    dynamicDelivery {
        deliveryType.set("on-demand")
    }
}