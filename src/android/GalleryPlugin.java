package com.megaphone.cordova.gallery;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import android.content.Intent;
import android.app.Activity;
import org.apache.cordova.CordovaActivity;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaResourceApi;
import org.apache.cordova.PluginResult;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CordovaInterface;
import android.util.Log;
import java.util.ArrayList;

public class GalleryPlugin extends CordovaPlugin {

	private static final String ACTION_SHOW_GALLERY = "viewGallery";
	private CallbackContext callbackContext;

	@Override
	public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {
		this.callbackContext = callbackContext;
		if (action.equals(ACTION_SHOW_GALLERY)) {

			JSONArray images = args.getJSONArray(0);
			int index = args.optInt(1,0);
			String[] urls = new String[images.length()];
			String[] captions = new String[images.length()];
			boolean[] canPin =  new boolean[images.length()];
			boolean[] canDelete = new boolean[images.length()];
			boolean[] pinned = new boolean[images.length()];

			for (int i=0; i < images.length(); i++) {
				JSONObject image = images.getJSONObject(i);
				urls[i] = image.getString("src");
				captions[i] = image.getString("caption");
				canPin[i] = image.getBoolean("canPin");
				canDelete[i] = image.getBoolean("canDelete");
				pinned[i] = image.getBoolean("pinned");
			}

			Intent intent = new Intent(this.cordova.getActivity().getApplicationContext(), GalleryActivity.class);

			intent.putExtra("urls", urls);
			intent.putExtra("captions", captions);
			intent.putExtra("canPin", canPin);
			intent.putExtra("canDelete", canDelete);
			intent.putExtra("pinned", pinned);
			intent.putExtra("index", index);
			this.cordova.startActivityForResult((CordovaPlugin) this, intent, 1);
			PluginResult r = new PluginResult(PluginResult.Status.NO_RESULT);
			r.setKeepCallback(true);
			callbackContext.sendPluginResult(r);
			return true;
		}
		return true;
	}

	public void onActivityResult(int requestCode, int resultCode, Intent intent) {
		// If image available
		if (resultCode == Activity.RESULT_OK) {
			String action = intent.getStringExtra("action");
			int index = intent.getIntExtra("index", -1);
			if (action != null && index != -1) {
				try {
				JSONObject response = new JSONObject();
				response.put("action", action);
				response.put("index", index);
				this.callbackContext.success(response);
				} catch (JSONException ex) {
					this.callbackContext.error("Failed to generate JSON response");
				}
			} else {
				this.callbackContext.success();
			}
			
		}
	}
}