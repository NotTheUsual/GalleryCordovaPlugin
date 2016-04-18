package com.megaphone.cordova.gallery;

import android.support.v4.view.MotionEventCompat;
import android.support.v4.view.ViewPager;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.MenuItem;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MotionEvent;
import android.view.View;
import android.widget.RelativeLayout;
import java.util.ArrayList;
import android.content.Intent;
import android.app.Activity;

import com.megaphone.cordova.gallery.adapters.GalleryImageAdapter;

public class GalleryActivity extends AppCompatActivity {
    ActionBar actionBar;
    ViewPager viewPager;
    private static FakeR fakeR;

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        final int itemId =  item.getItemId();
        Intent intent = new Intent();

        if (itemId == android.R.id.home) {
            this.finish();
            return true;
        } else if (itemId == fakeR.getId("id", "menu_delete")) {
            intent.putExtra("action", "delete");
            intent.putExtra("index", viewPager.getCurrentItem());
            setResult(Activity.RESULT_OK, intent);
            this.finish();
            return true;
        } else if (itemId == fakeR.getId("id", "menu_pin")) {
            intent.putExtra("action", "pin");
            intent.putExtra("index", viewPager.getCurrentItem());
            setResult(Activity.RESULT_OK, intent);
            this.finish();
            return true;
        } else if (itemId == fakeR.getId("id", "menu_save")) {
            intent.putExtra("action", "save");
            intent.putExtra("index", viewPager.getCurrentItem());
            setResult(Activity.RESULT_OK, intent);
            this.finish();
            return true;
        } else {
            return super.onOptionsItemSelected(item);
        }

        
        
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(fakeR.getId("menu", "menu_gallery"), menu);

        menu.getItem(0).setEnabled(false);

        return true;
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
        viewPager = (ViewPager) this.findViewById(fakeR.getId("id", "imagePager"));

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
                invalidateOptionsMenu();
            }

            @Override
            public void onPageScrollStateChanged(int state) {}
        });

    }
}
