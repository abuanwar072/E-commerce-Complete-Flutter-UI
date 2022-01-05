         Info adInfo = null;
          try {
            adInfo = AdvertisingIdClient.getAdvertisingIdInfo(getApplicationContext());

          } catch (IOException e) {
            // Unrecoverable error connecting to Google Play services (e.g.,
            // the old version of the service doesn't support getting AdvertisingId).

          } catch (GooglePlayServicesNotAvailableException e) {
            // Google Play services is not available entirely.
          } catch (IllegalStateException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (GooglePlayServicesRepairableException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
          final String id = adInfo.getId();
          final boolean isLAT = adInfo.isLimitAdTrackingEnabled();
