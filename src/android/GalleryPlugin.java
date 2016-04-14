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
			ArrayList<String> urlsList = new ArrayList<String>();
			ArrayList<String> captionsList = new ArrayList<String>();
			ArrayList<Boolean> canPin = new ArrayList<Boolean>();
			ArrayList<Boolean> canDelete = new ArrayList<Boolean>();

			for (int i=0; i < images.length(); i++) {
				urlsList.add(images.getJSONObject(i).getString("src"));
				captionsList.add(images.getJSONObject(i).getString("caption"));
			}

			String[] urls = new String[urlsList.size()];
			urls = urlsList.toArray(urls);
			String[] captions = new String[captionsList.size()];
			captions = captionsList.toArray(captions);
			Intent intent = new Intent(this.cordova.getActivity().getApplicationContext(), GalleryActivity.class);

			intent.putExtra("urls", urls);
			intent.putExtra("captions", captions);
			//intent.putExtra("canPin", null);
			//intent.putExtra("canDelete", null);
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