package com.megaphone.cordova.gallery.adapters;

import android.content.Context;
import android.support.v4.view.PagerAdapter;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;
import com.megaphone.cordova.gallery.controls.TouchImageView;
import com.squareup.picasso.Picasso;
import com.megaphone.cordova.gallery.FakeR;
import java.util.ArrayList;
import android.widget.ProgressBar;

/**
 * Created by elliotstokes on 11/04/2016.
 */
public class GalleryImageAdapter extends PagerAdapter {

    public static class Resource {
        private String _url;
        private String _caption;

        public Resource(String url, String caption) {
            this._url = url;
            this._caption = caption;
        }

        public String getCaption() {
            return this._caption;
        }

        public String getUrl() {
            return this._url;
        }

    }

    private final Context context;
    private static FakeR fakeR;

    private ArrayList<Resource> mResources = null;

    public GalleryImageAdapter(ArrayList<Resource> resources, Context context) {
        fakeR = new FakeR(context);
        this.context = context;
        this.mResources = resources;
    }

    @Override
    public int getCount() {
        return mResources.size();
    }

    @Override
    public boolean isViewFromObject(View view, Object object) {
        return view == ((RelativeLayout) object);
    }

    @Override
    public Object instantiateItem(ViewGroup container, int position) {
        final LayoutInflater layoutInflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        final View itemView = layoutInflater.inflate(fakeR.getId("layout", "image_layout"), container, false);

        final TouchImageView imageView = (TouchImageView) itemView.findViewById(fakeR.getId("id", "image"));
        final ProgressBar progress = (ProgressBar) itemView.findViewById(fakeR.getId("id", "spinner"));
        progress.setVisibility(View.VISIBLE);
        Picasso
                .with(context)
                .load(mResources.get(position).getUrl())
                .into(imageView, new  com.squareup.picasso.Callback() {
                        @Override
                        public void onSuccess() {
                            progress.setVisibility(View.GONE);
                            imageView.resetZoom();
                        }

                        @Override
                        public void onError() {
                            progress.setVisibility(View.GONE);
                        }
                    });

        TextView caption = (TextView) itemView.findViewById(fakeR.getId("id", "caption"));
        caption.setText(mResources.get(position).getCaption());
        container.addView(itemView);

        return itemView;
    }


    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        container.removeView((RelativeLayout) object);
    }

    @Override
    public CharSequence getPageTitle(int position) {
        return String.format("%s of %s", (position+1), mResources.size());

    }
}
