<!DOCTYPE html>
<html>
<head>
    <title>{{ $details['title'] }}</title>
</head>
<body>
    <h1>{{ $details['title'] }}</h1>
    <p>
    <?php
        // $string = 'freedom<br>freedom';
        $dom = new DOMDocument();
        $html_data  = mb_convert_encoding($details['body'] , 'HTML-ENTITIES', 'UTF-8');
        $dom->loadHTML($html_data);
        // $dom->encoding = 'UTF-8';
        // $documentElement = $dom->documentElement;
        echo $dom->saveHTML();
    ?>
    </p>
        
</body>
</html>