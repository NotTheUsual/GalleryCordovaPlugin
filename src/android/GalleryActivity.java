package com.megaphone.cordova.gallery;

import android.support.v4.view.MotionEventCompat;
import android.support.v4.view.ViewPager;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.widget.RelativeLayout;
import java.util.ArrayList;
import android.content.Intent;

import com.megaphone.cordova.gallery.adapters.GalleryImageAdapter;

public class GalleryActivity extends AppCompatActivity {
    ActionBar actionBar;
    private static FakeR fakeR;

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                this.finish();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        

        ArrayList<GalleryImageAdapter.Resource> resources = new ArrayList<GalleryImageAdapter.Resource>();
        Intent intent = getIntent();
        String[] captions = intent.getStringArrayExtra("captions");
        String[] urls = intent.getStringArrayExtra("urls");
        int index = intent.getIntExtra("index",0);
        if (urls != null && captions != null) {
            for(int i=0; i< urls.length; i++) {
                resources.add(new GalleryImageAdapter.Resource(urls[i], captions[i]));
            }
        }

        super.onCreate(savedInstanceState);
        fakeR = new FakeR(this);
        setContentView(fakeR.getId("layout", "activity_gallery"));
        actionBar = this.getSupportActionBar();
        actionBar.setDisplayHomeAsUpEnabled(true);
        final ViewPager viewPager = (ViewPager) this.findViewById(fakeR.getId("id", "imagePager"));

        final GalleryImageAdapter adapter = new GalleryImageAdapter(resources, this);
        viewPager.setAdapter(adapter);
        viewPager.setCurrentItem (index, false);
        actionBar.setTitle(adapter.getPageTitle(viewPager.getCurrentItem()));
        viewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {}

            @Override
            public void onPageSelected(int position) {
                actionBar.setTitle(adapter.getPageTitle(position));
            }

            @Override
            public void onPageScrollStateChanged(int state) {}
        });

    }
}
