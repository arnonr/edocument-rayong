<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Storage;

class MyMail extends Mailable
{
    use Queueable, SerializesModels;

    public $details;
    public $title;
    public $template;

    /**
     * Create a new message instance.
     *
     * @return void
     */
    public function __construct($details, $title, $template, $file)
    {
        $this->details = $details;
        $this->title = $title;
        $this->template = $template;
        $this->file = $file;
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        if($this->template == 'bookOutSend'){
            return $this->subject($this->title)
                    ->view('emails.bookOutSend');
                    // ->attach(Storage::disk('public')->getAdapter()->getPathPrefix().$this->file);
        }

        if($this->template == 'bookInSend'){
            return $this->subject($this->title)
                    ->view('emails.bookInSend');
                    // ->attach(Storage::disk('public')->getAdapter()->getPathPrefix().$this->file);
        }
        
    }
}
